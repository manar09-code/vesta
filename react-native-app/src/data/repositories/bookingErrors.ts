export type BookingFailureCode =
  | 'notSignedIn'
  | 'ownListing'
  | 'datesRequired'
  | 'tooManyGuests'
  | 'messageTooLong'
  | 'nightTaken'
  | 'notPending'
  | 'permissionDenied'
  | 'unknown';

export class BookingFailure extends Error {
  readonly code: BookingFailureCode;

  constructor(code: BookingFailureCode) {
    super(code);
    this.name = 'BookingFailure';
    this.code = code;
  }
}

export function mapBookingCode(code: string): BookingFailureCode {
  return code === 'permission-denied' ? 'permissionDenied' : 'unknown';
}