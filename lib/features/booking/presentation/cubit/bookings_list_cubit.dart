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
      bookings.where((b) => b.status == 'Confirmed').toList();

  List<BookingEntity> get past =>
      bookings.where((b) => b.status == 'Completed').toList();

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

  StreamSubscription<List<BookingEntity>>? _subscription;

  BookingsListCubit({
    required this.getBookingsUseCase,
    required this.updatePastBookingsUseCase,
    required this.cancelBookingUseCase,
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
      // Stream subscription will automatically refresh the list after deletion
    } catch (e) {
      emit(BookingsListError('Could not cancel booking. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
