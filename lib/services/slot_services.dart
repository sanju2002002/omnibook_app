import '../models/booking.dart';

class SlotService {
  static const int totalCounters = 3;

  /// 
  static const int openingHour = 9;
  static const int closingHour = 18;
  static const int slotInterval = 30;

  /// 
  static DateTime _baseDate([DateTime? date]) {
    final now = date ?? DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// 
  static DateTime _normalize(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
  }

  ///  GENERATE SLOTS
  static List<DateTime> generateSlots({DateTime? date}) {
    final base = _baseDate(date);

    DateTime start = DateTime(base.year, base.month, base.day, openingHour, 0);
    DateTime end = DateTime(base.year, base.month, base.day, closingHour, 0);

    final slots = <DateTime>[];

    while (start.isBefore(end)) {
      slots.add(start);
      start = start.add(const Duration(minutes: slotInterval));
    }

    return slots;
  }

  ///  OVERLAP CHECK (CORE)
  static bool _hasOverlap({
    required DateTime start,
    required DateTime end,
    required Booking booking,
  }) {
    final s = _normalize(start);
    final e = _normalize(end);
    final bs = _normalize(booking.start);
    final be = _normalize(booking.end);

    return s.isBefore(be) && e.isAfter(bs);
  }

  ///  CHECK IF COUNTER IS FREE
  static bool _isCounterFree({
    required int counter,
    required DateTime start,
    required DateTime end,
    required List<Booking> bookings,
  }) {
    final counterBookings = bookings.where((b) => b.counterId == counter);

    for (final booking in counterBookings) {
      if (_hasOverlap(start: start, end: end, booking: booking)) {
        return false; // ❌ blocked
      }
    }

    return true; // 
  }

  ///  CLOSING TIME
  static DateTime _closingTime(DateTime date) {
    return DateTime(date.year, date.month, date.day, closingHour, 0);
  }

  ///  SLOT AVAILABLE
  static bool isSlotAvailable({
    required DateTime slotStart,
    required int duration,
    required List<Booking> bookings,
  }) {
    final start = _normalize(slotStart);
    final end = _normalize(start.add(Duration(minutes: duration)));

    ///  OUTSIDE BUSINESS HOURS
    if (end.isAfter(_closingTime(start))) return false;

    ///  CHECK EACH COUNTER
    for (int counter = 1; counter <= totalCounters; counter++) {
      if (_isCounterFree(
        counter: counter,
        start: start,
        end: end,
        bookings: bookings,
      )) {
        return true; // at least one counter free
      }
    }

    return false;
  }

  ///  AVAILABLE COUNTERS COUNT
  static int availableCounters({
    required DateTime slotStart,
    required int duration,
    required List<Booking> bookings,
  }) {
    final start = _normalize(slotStart);
    final end = _normalize(start.add(Duration(minutes: duration)));

    if (end.isAfter(_closingTime(start))) return 0;

    int count = 0;

    for (int counter = 1; counter <= totalCounters; counter++) {
      if (_isCounterFree(
        counter: counter,
        start: start,
        end: end,
        bookings: bookings,
      )) {
        count++;
      }
    }

    return count;
  }

  ///  GET FIRST AVAILABLE COUNTER
  static int? getAvailableCounter({
    required DateTime slotStart,
    required int duration,
    required List<Booking> bookings,
  }) {
    final start = _normalize(slotStart);
    final end = _normalize(start.add(Duration(minutes: duration)));

    if (end.isAfter(_closingTime(start))) return null;

    for (int counter = 1; counter <= totalCounters; counter++) {
      if (_isCounterFree(
        counter: counter,
        start: start,
        end: end,
        bookings: bookings,
      )) {
        return counter;
      }
    }

    return null;
  }
}
