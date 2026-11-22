import {
  collection,
  doc,
  getDocs,
  serverTimestamp,
  setDoc,
  Timestamp,
} from 'firebase/firestore';
import { auth, db } from '../firebase';
import { errorCodeOf } from './authErrors';
import { BookingFailure, mapBookingCode } from './bookingErrors';
import { bookingIdFor, maxBookingMessageLength } from '../models/booking';
import {
  hasBlockedNight,
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
}

export const bookingRepository = new BookingRepository();