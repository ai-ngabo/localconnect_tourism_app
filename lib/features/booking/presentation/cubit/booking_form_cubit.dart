import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/add_booking_usecase.dart';
import 'booking_form_state.dart';

class BookingFormCubit extends Cubit<BookingFormState> {
  final AddBookingUseCase addBookingUseCase;

  BookingFormCubit({required this.addBookingUseCase})
      : super(const BookingFormInitial());

  void selectDate(DateTime date) {
    final current = state;
    if (current is BookingFormInitial) {
      emit(current.copyWith(selectedDate: date));
    }
  }

  void incrementGuests() {
    final current = state;
    if (current is BookingFormInitial) {
      emit(current.copyWith(guests: current.guests + 1));
    }
  }

  void decrementGuests() {
    final current = state;
    if (current is BookingFormInitial && current.guests > 1) {
      emit(current.copyWith(guests: current.guests - 1));
    }
  }

  Future<void> confirmBooking(BookingEntity booking) async {
    emit(const BookingFormSubmitting());
    try {
      await addBookingUseCase(AddBookingParams(booking: booking));
      emit(const BookingFormSuccess());
    } catch (_) {
      emit(const BookingFormError(
          'Could not save booking. Please check your connection and try again.'));
    }
  }

  void reset() {
    emit(const BookingFormInitial());
  }
}
