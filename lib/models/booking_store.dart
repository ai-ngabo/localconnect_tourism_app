import 'package:community_touring_rwanda/models/tour_model.dart';
import 'package:community_touring_rwanda/models/user_model.dart';

class BookingStore {
  BookingStore._();

  static final List<Booking> bookings = [];

  static void addBooking(Booking booking) {
    bookings.add(booking);
  }

  static List<Booking> bookingsForUser(User? user) {
    if (user == null) return [];
    return bookings.where((b) => b.userEmail == user.email).toList();
  }
}
