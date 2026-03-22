import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../tourism/domain/entities/tour_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final FirebaseFirestore firestore;

  BookingRepositoryImpl({required this.firestore});

  CollectionReference get _bookingsRef => firestore.collection('bookings');

  @override
  Future<void> addBooking(BookingEntity booking) async {
    await _bookingsRef.doc(booking.id).set(_toMap(booking));
  }

  @override
  Stream<List<BookingEntity>> getBookingsForUser(String userEmail) {
    if (userEmail.isEmpty) return const Stream.empty();

    return _bookingsRef
        .where('userEmail', isEqualTo: userEmail)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  @override
  Future<void> updatePastBookings(String userEmail) async {
    if (userEmail.isEmpty) return;

    final now = DateTime.now();
    final querySnapshot = await _bookingsRef
        .where('userEmail', isEqualTo: userEmail)
        .where('status', isEqualTo: 'Confirmed')
        .get();

    for (final doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final dateValue = data['date'];
      if (dateValue is! Timestamp) continue;

      final bookingDate = dateValue.toDate();
      if (bookingDate.isBefore(now)) {
        await doc.reference.update({'status': 'Completed'});
      }
    }
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await _bookingsRef.doc(bookingId).delete();
  }

  Map<String, dynamic> _toMap(BookingEntity booking) {
    return {
      'tourId': booking.tour.id,
      'tourTitle': booking.tour.title,
      'tourDescription': booking.tour.description,
      'tourImageUrl': booking.tour.imageUrl,
      'tourDuration': booking.tour.duration,
      'tourPriceRwf': booking.tour.priceRwf,
      'date': Timestamp.fromDate(booking.date),
      'guests': booking.guests,
      'totalCost': booking.totalCost,
      'status': booking.status,
      'userEmail': booking.userEmail,
    };
  }

  BookingEntity _fromMap(String id, Map<String, dynamic> map) {
    final dateValue = map['date'];
    final DateTime bookingDate = dateValue is Timestamp
        ? dateValue.toDate()
        : DateTime.now();

    final tour = TourEntity(
      id: map['tourId'] as String? ?? '1',
      title: map['tourTitle'] as String? ?? '',
      description: map['tourDescription'] as String? ?? '',
      imageUrl: map['tourImageUrl'] as String? ?? 'cultural_village',
      duration: map['tourDuration'] as String? ?? '',
      priceRwf: map['tourPriceRwf'] as int? ?? 0,
      rating: 4.8,
    );

    return BookingEntity(
      id: id,
      tour: tour,
      date: bookingDate,
      guests: map['guests'] as int? ?? 1,
      totalCost: map['totalCost'] as int? ?? 0,
      status: map['status'] as String? ?? 'Confirmed',
      userEmail: map['userEmail'] as String?,
    );
  }
}
