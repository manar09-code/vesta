import {
  collection,
  doc,
  getDocs,
  onSnapshot,
  query,
  serverTimestamp,
  setDoc,
  Timestamp,
  Unsubscribe,
  where,
  writeBatch,
} from 'firebase/firestore';
import { auth, db } from '../firebase';
import { errorCodeOf } from './authErrors';
import { BookingFailure, mapBookingCode } from './bookingErrors';
import {
  Booking,
  bookingFromData,
  bookingIdFor,
  maxBookingMessageLength,
} from '../models/booking';
import {
  hasBlockedNight,
  nightKey,
  nightsOf,
  totalPrice,
} from '../../features/bookings/bookingDates';

export type BookingListing = {
  id: string;
  ownerId: string;
  price: number;
  currency: string;
  maxGuests: number | null;
};

export type BookingInput = {
  checkIn: Date;
  checkOut: Date;
  guests: number;
  message: string;
};

/** Newest first. A booking whose time is still null was just written here. */
function newestFirst(bookings: Booking[]): Booking[] {
  return [...bookings].sort((a, b) => {
    const ta = a.createdAt;
    const tb = b.createdAt;
    if (ta === null && tb === null) {
      return 0;
    }
    if (ta === null) {
      return -1;
    }
    if (tb === null) {
      return 1;
    }
    return tb.getTime() - ta.getTime();
  });
}

/** Only place that talks to `bookings` and `listings/{id}/blockedNights` (VST-85). */
export class BookingRepository {
  /** `yyyy-MM-dd` keys of the nights that are already taken. */
  async getBlockedNights(listingId: string): Promise<Set<string>> {
    try {
      const snapshot = await getDocs(
        collection(db, 'listings', listingId, 'blockedNights'),
      );
      return new Set(snapshot.docs.map(item => item.id));
    } catch (error) {
      throw new BookingFailure(mapBookingCode(errorCodeOf(error)));
    }
  }

  /** Writes `bookings/{listingId}_{guestId}` with status pending. */
  async createBooking(
    listing: BookingListing,
    input: BookingInput,
  ): Promise<void> {
    const user = auth.currentUser;
    if (user === null) {
      throw new BookingFailure('notSignedIn');
    }
    if (listing.ownerId === user.uid) {
      throw new BookingFailure('ownListing');
    }

    const nights = nightsOf(input.checkIn, input.checkOut).length;
    if (nights < 1) {
      throw new BookingFailure('datesRequired');
    }
    const maxGuests = listing.maxGuests ?? 30;
    if (input.guests < 1 || input.guests > maxGuests) {
      throw new BookingFailure('tooManyGuests');
    }
    const message = input.message.trim();
    if (message.length > maxBookingMessageLength) {
      throw new BookingFailure('messageTooLong');
    }

    // Checked again right before sending (another guest may have been accepted).
    const blocked = await this.getBlockedNights(listing.id);
    if (hasBlockedNight(input.checkIn, input.checkOut, blocked)) {
      throw new BookingFailure('nightTaken');
    }

    try {
      await setDoc(doc(db, 'bookings', bookingIdFor(listing.id, user.uid)), {
        listingId: listing.id,
        guestId: user.uid,
        ownerId: listing.ownerId,
        checkIn: Timestamp.fromDate(input.checkIn),
        checkOut: Timestamp.fromDate(input.checkOut),
        guests: input.guests,
        nights,
        total: totalPrice(nights, listing.price),
        currency: listing.currency,
        message,
        status: 'pending',
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp(),
      });
    } catch (error) {
      throw new BookingFailure(mapBookingCode(errorCodeOf(error)));
    }
  }

  /** Live list of the trips of the signed-in guest, newest first. */
  watchMyTrips(
    onData: (bookings: Booking[]) => void,
    onError: (failure: BookingFailure) => void,
  ): Unsubscribe {
    return this.watch('guestId', onData, onError);
  }

  /** Live list of the requests received by the signed-in owner, newest first. */
  watchRequests(
    onData: (bookings: Booking[]) => void,
    onError: (failure: BookingFailure) => void,
  ): Unsubscribe {
    return this.watch('ownerId', onData, onError);
  }

  private watch(
    field: 'guestId' | 'ownerId',
    onData: (bookings: Booking[]) => void,
    onError: (failure: BookingFailure) => void,
  ): Unsubscribe {
    const user = auth.currentUser;
    if (user === null) {
      onData([]);
      return () => {};
    }
    // Sorted here (not in the query) so no Firestore index is needed.
    const bookings = query(
      collection(db, 'bookings'),
      where(field, '==', user.uid),
    );
    return onSnapshot(
      bookings,
      snapshot => {
        onData(
          newestFirst(
            snapshot.docs.map(item => bookingFromData(item.id, item.data())),
          ),
        );
      },
      error => onError(new BookingFailure(mapBookingCode(errorCodeOf(error)))),
    );
  }

  /**
   * The owner accepts or declines a pending request. Accepting writes the
   * blocked nights in the same batch, so the status and the nights never
   * disagree.
   */
  async decide(
    booking: Booking,
    decision: 'accepted' | 'declined',
  ): Promise<void> {
    const user = auth.currentUser;
    if (user === null) {
      throw new BookingFailure('notSignedIn');
    }
    if (user.uid !== booking.ownerId) {
      throw new BookingFailure('permissionDenied');
    }
    if (booking.status !== 'pending') {
      throw new BookingFailure('notPending');
    }
    if (booking.checkIn === null || booking.checkOut === null) {
      throw new BookingFailure('datesRequired');
    }

    const nights = nightsOf(booking.checkIn, booking.checkOut);
    if (decision === 'accepted') {
      const blocked = await this.getBlockedNights(booking.listingId);
      if (hasBlockedNight(booking.checkIn, booking.checkOut, blocked)) {
        throw new BookingFailure('nightTaken');
      }
    }

    const batch = writeBatch(db);
    batch.update(doc(db, 'bookings', booking.id), {
      status: decision,
      updatedAt: serverTimestamp(),
    });
    if (decision === 'accepted') {
      for (const night of nights) {
        batch.set(
          doc(db, 'listings', booking.listingId, 'blockedNights', nightKey(night)),
          {
            bookingId: booking.id,
            guestId: booking.guestId,
            createdAt: serverTimestamp(),
          },
        );
      }
    }
    try {
      await batch.commit();
    } catch (error) {
      throw new BookingFailure(mapBookingCode(errorCodeOf(error)));
    }
  }

  /** The guest cancels a pending or accepted request (frees the nights). */
  async cancel(booking: Booking): Promise<void> {
    const user = auth.currentUser;
    if (user === null) {
      throw new BookingFailure('notSignedIn');
    }
    if (user.uid !== booking.guestId) {
      throw new BookingFailure('permissionDenied');
    }
    if (booking.status !== 'pending' && booking.status !== 'accepted') {
      throw new BookingFailure('notPending');
    }

    const batch = writeBatch(db);
    batch.update(doc(db, 'bookings', booking.id), {
      status: 'cancelled',
      updatedAt: serverTimestamp(),
    });
    if (
      booking.status === 'accepted' &&
      booking.checkIn !== null &&
      booking.checkOut !== null
    ) {
      for (const night of nightsOf(booking.checkIn, booking.checkOut)) {
        batch.delete(
          doc(db, 'listings', booking.listingId, 'blockedNights', nightKey(night)),
        );
      }
    }
    try {
      await batch.commit();
    } catch (error) {
      throw new BookingFailure(mapBookingCode(errorCodeOf(error)));
    }
  }
}

export const bookingRepository = new BookingRepository();