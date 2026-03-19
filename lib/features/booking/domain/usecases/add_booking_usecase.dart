import '../../../../core/usecases/usecase.dart';
import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class AddBookingParams {
  final BookingEntity booking;

  const AddBookingParams({required this.booking});
}

class AddBookingUseCase implements UseCase<void, AddBookingParams> {
  final BookingRepository repository;

  AddBookingUseCase(this.repository);

  @override
  Future<void> call(AddBookingParams params) {
    return repository.addBooking(params.booking);
  }
}
