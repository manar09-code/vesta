export function nightKey(date: Date): string {
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

export function nightsOf(checkIn: Date, checkOut: Date): Date[] {
  const nights: Date[] = [];
  let day = new Date(
    checkIn.getFullYear(),
    checkIn.getMonth(),
    checkIn.getDate(),
  );
  const end = new Date(
    checkOut.getFullYear(),
    checkOut.getMonth(),
    checkOut.getDate(),
  );
  while (day < end) {
    nights.push(day);
    day = new Date(day.getFullYear(), day.getMonth(), day.getDate() + 1);
  }
  return nights;
}

export function nightsCount(checkIn: Date, checkOut: Date): number {
  return nightsOf(checkIn, checkOut).length;
}

export function hasBlockedNight(
  checkIn: Date,
  checkOut: Date,
  blocked: Set<string>,
): boolean {
  return nightsOf(checkIn, checkOut).some(night => blocked.has(nightKey(night)));
}

export function totalPrice(nights: number, pricePerNight: number): number {
  return nights * pricePerNight;
}

export function dateFromKey(key: string): Date {
  const [year, month, day] = key.split('-').map(Number);
  return new Date(year, month - 1, day);
}