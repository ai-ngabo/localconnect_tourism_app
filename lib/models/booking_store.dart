import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_touring_rwanda/models/tour_model.dart';
import 'package:community_touring_rwanda/models/user_model.dart';

class BookingStore {
  BookingStore._();

  static final _bookingsRef =
      FirebaseFirestore.instance.collection('bookings');

  /// Persist a booking to Firestore.
  static Future<void> addBooking(Booking booking) async {
    await _bookingsRef.doc(booking.id).set(booking.toMap());
  }

  /// Stream bookings for a given user.
  static Stream<List<Booking>> bookingsForUser(User? user) {
    if (user == null || user.email.isEmpty) {
      return const Stream.empty();
    }

    return _bookingsRef
        .where('userEmail', isEqualTo: user.email)
        // No explicit orderBy to avoid composite index requirement / errors.
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Booking.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
