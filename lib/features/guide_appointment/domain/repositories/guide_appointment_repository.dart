import '../entities/guide_appointment_entity.dart';

abstract class GuideAppointmentRepository {
  Future<void> addAppointment(GuideAppointmentEntity appointment);
  Stream<List<GuideAppointmentEntity>> getAppointmentsForUser(String userEmail);
  Future<void> deleteAppointment(String appointmentId);
}
