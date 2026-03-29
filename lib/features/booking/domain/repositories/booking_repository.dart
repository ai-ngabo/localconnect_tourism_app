import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<void> addBooking(BookingEntity booking);
  Stream<List<BookingEntity>> getBookingsForUser(String userEmail);
  Future<void> updatePastBookings(String userEmail);
  Future<void> cancelBooking(String bookingId);
  Future<void> deleteBooking(String bookingId);
  Future<void> updateBooking({
    required String bookingId,
    DateTime? date,
    int? guests,
    int? totalCost,
  });
}
