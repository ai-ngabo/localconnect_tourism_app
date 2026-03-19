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
