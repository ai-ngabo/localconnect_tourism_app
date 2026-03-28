import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/get_bookings_usecase.dart';

// ── State ──────────────────────────────────────────────────────────────────
abstract class BookingsListState extends Equatable {
  const BookingsListState();

  @override
  List<Object?> get props => [];
}

class BookingsListInitial extends BookingsListState {
  const BookingsListInitial();
}

class BookingsListLoading extends BookingsListState {
  const BookingsListLoading();
}

class BookingsListLoaded extends BookingsListState {
  final List<BookingEntity> bookings;

  const BookingsListLoaded(this.bookings);

  List<BookingEntity> get upcoming =>
      bookings.where((b) => b.status == 'Confirmed').toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<BookingEntity> get past =>
      bookings.where((b) => b.status == 'Completed').toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  List<BookingEntity> get cancelled =>
      bookings.where((b) => b.status == 'Cancelled').toList()
        ..sort((a, b) => b.date.compareTo(a.date));

  @override
  List<Object?> get props => [bookings];
}

class BookingsListError extends BookingsListState {
  final String message;

  const BookingsListError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Cubit ──────────────────────────────────────────────────────────────────
class BookingsListCubit extends Cubit<BookingsListState> {
  final GetBookingsUseCase getBookingsUseCase;
  final UpdatePastBookingsUseCase updatePastBookingsUseCase;
  final CancelBookingUseCase cancelBookingUseCase;
  final DeleteBookingUseCase deleteBookingUseCase;
  final UpdateBookingUseCase updateBookingUseCase;

  StreamSubscription<List<BookingEntity>>? _subscription;

  BookingsListCubit({
    required this.getBookingsUseCase,
    required this.updatePastBookingsUseCase,
    required this.cancelBookingUseCase,
    required this.deleteBookingUseCase,
    required this.updateBookingUseCase,
  }) : super(const BookingsListInitial());

  Future<void> watchBookings(String userEmail) async {
    emit(const BookingsListLoading());

    // Mark past bookings as completed before subscribing
    await updatePastBookingsUseCase(userEmail);

    _subscription = getBookingsUseCase(userEmail).listen(
      (bookings) => emit(BookingsListLoaded(bookings)),
      onError: (e) => emit(BookingsListError(e.toString())),
    );
  }

  /// Deletes (cancels) a booking document from Firestore.
  Future<void> cancelBooking(String bookingId) async {
    try {
      await cancelBookingUseCase(bookingId);
    } catch (e) {
      emit(BookingsListError('Could not cancel booking. Please try again.'));
    }
  }

  /// Permanently deletes a booking document from Firestore.
  Future<void> deleteBooking(String bookingId) async {
    try {
      await deleteBookingUseCase(bookingId);
    } catch (e) {
      emit(const BookingsListError('Could not delete booking. Please try again.'));
    }
  }

  /// Updates date and/or guests for an existing booking.
  Future<void> updateBooking({
    required String bookingId,
    DateTime? date,
    int? guests,
    int? totalCost,
  }) async {
    try {
      await updateBookingUseCase(
        bookingId: bookingId,
        date: date,
        guests: guests,
        totalCost: totalCost,
      );
    } catch (e) {
      emit(BookingsListError('Could not update booking. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
