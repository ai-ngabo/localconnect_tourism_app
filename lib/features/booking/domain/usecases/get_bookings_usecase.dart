import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingsUseCase {
  final BookingRepository repository;

  GetBookingsUseCase(this.repository);

  Stream<List<BookingEntity>> call(String userEmail) {
    return repository.getBookingsForUser(userEmail);
  }
}

class UpdatePastBookingsUseCase {
  final BookingRepository repository;

  UpdatePastBookingsUseCase(this.repository);

  Future<void> call(String userEmail) {
    return repository.updatePastBookings(userEmail);
  }
}

class CancelBookingUseCase {
  final BookingRepository repository;

  CancelBookingUseCase(this.repository);

  Future<void> call(String bookingId) {
    return repository.cancelBooking(bookingId);
  }
}

class DeleteBookingUseCase {
  final BookingRepository repository;

  DeleteBookingUseCase(this.repository);

  Future<void> call(String bookingId) {
    return repository.deleteBooking(bookingId);
  }
}

class UpdateBookingUseCase {
  final BookingRepository repository;

  UpdateBookingUseCase(this.repository);

  Future<void> call({
    required String bookingId,
    DateTime? date,
    int? guests,
    int? totalCost,
  }) {
    return repository.updateBooking(
      bookingId: bookingId,
      date: date,
      guests: guests,
      totalCost: totalCost,
    );
  }
}
