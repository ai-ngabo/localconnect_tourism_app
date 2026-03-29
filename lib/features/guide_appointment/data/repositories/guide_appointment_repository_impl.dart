import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/guide_appointment_entity.dart';
import '../../domain/repositories/guide_appointment_repository.dart';

class GuideAppointmentRepositoryImpl implements GuideAppointmentRepository {
  final FirebaseFirestore firestore;

  GuideAppointmentRepositoryImpl({required this.firestore});

  CollectionReference get _ref => firestore.collection('guide_appointments');

  @override
  Future<void> addAppointment(GuideAppointmentEntity appointment) async {
    await _ref.doc(appointment.id).set({
      'guideName': appointment.guideName,
      'guideSpecialty': appointment.guideSpecialty,
      'guideId': appointment.guideId,
      'date': Timestamp.fromDate(appointment.date),
      'timeSlot': appointment.timeSlot,
      'status': appointment.status,
      'userEmail': appointment.userEmail,
      'createdAt': Timestamp.fromDate(appointment.createdAt),
    });
  }

  @override
  Stream<List<GuideAppointmentEntity>> getAppointmentsForUser(
      String userEmail) {
    if (userEmail.isEmpty) return const Stream.empty();

    return _ref
        .where('userEmail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final dateVal = data['date'];
              final createdVal = data['createdAt'];
              return GuideAppointmentEntity(
                id: doc.id,
                guideName: data['guideName'] as String? ?? '',
                guideSpecialty: data['guideSpecialty'] as String? ?? '',
                guideId: data['guideId'] as String? ?? '',
                date: dateVal is Timestamp
                    ? dateVal.toDate()
                    : DateTime.now(),
                timeSlot: data['timeSlot'] as String? ?? '',
                status: data['status'] as String? ?? 'Confirmed',
                userEmail: data['userEmail'] as String?,
                createdAt: createdVal is Timestamp
                    ? createdVal.toDate()
                    : DateTime.now(),
              );
            }).toList());
  }

  @override
  Future<void> deleteAppointment(String appointmentId) async {
    await _ref.doc(appointmentId).delete();
  }
}
