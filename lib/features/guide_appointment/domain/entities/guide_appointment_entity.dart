import 'package:equatable/equatable.dart';

class GuideAppointmentEntity extends Equatable {
  final String id;
  final String guideName;
  final String guideSpecialty;
  final String guideId;
  final DateTime date;
  final String timeSlot;
  final String status; // 'Confirmed', 'Completed', 'Cancelled'
  final String? userEmail;
  final DateTime createdAt;

  const GuideAppointmentEntity({
    required this.id,
    required this.guideName,
    required this.guideSpecialty,
    required this.guideId,
    required this.date,
    required this.timeSlot,
    required this.status,
    this.userEmail,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [id, guideName, guideSpecialty, guideId, date, timeSlot, status, userEmail, createdAt];
}
