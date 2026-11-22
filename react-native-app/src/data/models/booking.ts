import type { DocumentData } from 'firebase/firestore';

export type BookingStatus = 'pending' | 'accepted' | 'declined' | 'cancelled';

export const maxBookingMessageLength = 500;

/** One booking per guest and per listing (docs/data-model.md). */
export function bookingIdFor(listingId: string, guestId: string): string {
  return `${listingId}_${guestId}`;
}

export type Booking = {
  id: string;
  listingId: string;
  guestId: string;
  ownerId: string;
  checkIn: Date | null;
  checkOut: Date | null;
  guests: number;
  nights: number;
  total: number;
  currency: string;
  message: string;
  status: BookingStatus;
  createdAt: Date | null;
};

function toDate(value: unknown): Date | null {
  if (
    typeof value === 'object' &&
    value !== null &&
    typeof (value as { toDate?: unknown }).toDate === 'function'
  ) {
    return (value as { toDate: () => Date }).toDate();
  }
  return null;
}

const text = (value: unknown): string =>
  typeof value === 'string' ? value : '';

const num = (value: unknown): number =>
  typeof value === 'number' ? value : 0;

export function bookingFromData(
  id: string,
  data: DocumentData | undefined,
): Booking {
  const raw = data ?? {};
  const status = raw.status;
  return {
    id,
    listingId: text(raw.listingId),
    guestId: text(raw.guestId),
    ownerId: text(raw.ownerId),
    checkIn: toDate(raw.checkIn),
    checkOut: toDate(raw.checkOut),
    guests: num(raw.guests),
    nights: num(raw.nights),
    total: num(raw.total),
    currency: text(raw.currency),
    message: text(raw.message),
    status:
      status === 'accepted' || status === 'declined' || status === 'cancelled'
        ? status
        : 'pending',
    createdAt: toDate(raw.createdAt),
  };
}