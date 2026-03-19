import 'package:equatable/equatable.dart';

abstract class BookingFormState extends Equatable {
  const BookingFormState();

  @override
  List<Object?> get props => [];
}

class BookingFormInitial extends BookingFormState {
  final DateTime? selectedDate;
  final int guests;

  const BookingFormInitial({
    this.selectedDate,
    this.guests = 1,
  });

  BookingFormInitial copyWith({DateTime? selectedDate, int? guests}) {
    return BookingFormInitial(
      selectedDate: selectedDate ?? this.selectedDate,
      guests: guests ?? this.guests,
    );
  }

  @override
  List<Object?> get props => [selectedDate, guests];
}

class BookingFormSubmitting extends BookingFormState {
  const BookingFormSubmitting();
}

class BookingFormSuccess extends BookingFormState {
  const BookingFormSuccess();
}

class BookingFormError extends BookingFormState {
  final String message;

  const BookingFormError(this.message);

  @override
  List<Object?> get props => [message];
}
