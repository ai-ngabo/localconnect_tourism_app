import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/guide_appointment_entity.dart';
import '../../domain/repositories/guide_appointment_repository.dart';

// ── States ─────────────────────────────────────────────────────────────────
abstract class GuideAppointmentState extends Equatable {
  const GuideAppointmentState();

  @override
  List<Object?> get props => [];
}

class GuideAppointmentInitial extends GuideAppointmentState {
  const GuideAppointmentInitial();
}

class GuideAppointmentLoading extends GuideAppointmentState {
  const GuideAppointmentLoading();
}

class GuideAppointmentLoaded extends GuideAppointmentState {
  final List<GuideAppointmentEntity> appointments;

  const GuideAppointmentLoaded(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

class GuideAppointmentError extends GuideAppointmentState {
  final String message;

  const GuideAppointmentError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Cubit ──────────────────────────────────────────────────────────────────
class GuideAppointmentCubit extends Cubit<GuideAppointmentState> {
  final GuideAppointmentRepository repository;

  StreamSubscription<List<GuideAppointmentEntity>>? _subscription;

  GuideAppointmentCubit({required this.repository})
      : super(const GuideAppointmentInitial());

  void watchAppointments(String userEmail) {
    emit(const GuideAppointmentLoading());
    _subscription = repository.getAppointmentsForUser(userEmail).listen(
      (appointments) => emit(GuideAppointmentLoaded(appointments)),
      onError: (e) => emit(GuideAppointmentError(e.toString())),
    );
  }

  Future<void> addAppointment(GuideAppointmentEntity appointment) async {
    try {
      await repository.addAppointment(appointment);
    } catch (e) {
      emit(const GuideAppointmentError(
          'Could not book appointment. Please try again.'));
    }
  }

  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await repository.deleteAppointment(appointmentId);
    } catch (e) {
      emit(const GuideAppointmentError(
          'Could not delete appointment. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
