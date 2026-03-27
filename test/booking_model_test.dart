import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_touring_rwanda/models/tour_model.dart';

void main() {
  group('Booking Model', () {
    late Tour testTour;
    late DateTime testDate;

    setUp(() {
      testTour = const Tour(
        id: '1',
        title: 'Test Tour',
        description: 'Test Description',
        imageUrl: 'test_image',
        duration: '2 Hours',
        priceRwf: 100,
      );
      testDate = DateTime(2024, 3, 27);
    });

    test('Booking constructor creates instance with correct values', () {
      final booking = Booking(
        id: '1',
        tour: Tour(
          id: '1',
          title: 'Test Tour',
          description: 'Test Description',
          imageUrl: 'test_image',
          duration: '2 Hours',
          priceRwf: 100,
        ),
        date: DateTime(2024, 3, 27),
        guests: 2,
        totalCost: 200,
        status: 'Confirmed',
        userEmail: 'test@example.com',
      );

      expect(booking.id, '1');
      expect(booking.tour.id, '1');
      expect(booking.date, DateTime(2024, 3, 27));
      expect(booking.guests, 2);
      expect(booking.totalCost, 200);
      expect(booking.status, 'Confirmed');
      expect(booking.userEmail, 'test@example.com');
    });

    test('toMap converts Booking to Map correctly', () {
      final booking = Booking(
        id: '1',
        tour: testTour,
        date: testDate,
        guests: 2,
        totalCost: 200,
        status: 'Confirmed',
        userEmail: 'test@example.com',
      );

      final map = booking.toMap();

      expect(map['tourId'], '1');
      expect(map['tourTitle'], 'Test Tour');
      expect(map['date'], isA<Timestamp>());
      expect(map['guests'], 2);
      expect(map['totalCost'], 200);
      expect(map['status'], 'Confirmed');
      expect(map['userEmail'], 'test@example.com');
    });

    test('fromMap creates Booking from Map correctly', () {
      final timestamp = Timestamp.fromDate(testDate);
      final map = {
        'tourId': '1',
        'tourTitle': 'Test Tour',
        'tourDescription': 'Test Description',
        'tourImageUrl': 'test_image',
        'tourDuration': '2 Hours',
        'tourPriceRwf': 100,
        'date': timestamp,
        'guests': 2,
        'totalCost': 200,
        'status': 'Confirmed',
        'userEmail': 'test@example.com',
      };

      final booking = Booking.fromMap('1', map);

      expect(booking.id, '1');
      expect(booking.tour.id, '1');
      expect(booking.tour.title, 'Test Tour');
      expect(booking.date, testDate);
      expect(booking.guests, 2);
      expect(booking.totalCost, 200);
      expect(booking.status, 'Confirmed');
      expect(booking.userEmail, 'test@example.com');
    });

    test('fromMap handles missing fields with defaults', () {
      final map = {
        'date': Timestamp.fromDate(testDate),
      };

      final booking = Booking.fromMap('1', map);

      expect(booking.id, '1');
      expect(booking.tour.id, '1');
      expect(booking.guests, 1);
      expect(booking.totalCost, 0);
      expect(booking.status, 'Confirmed');
      expect(booking.userEmail, null);
    });

    test('fromMap handles DateTime directly', () {
      final map = {
        'date': testDate,
        'guests': 2,
        'totalCost': 200,
        'status': 'Confirmed',
      };

      final booking = Booking.fromMap('1', map);

      expect(booking.date, testDate);
    });

    test('fromMap handles invalid date with current date', () {
      final map = {
        'date': 'invalid',
        'guests': 2,
        'totalCost': 200,
        'status': 'Confirmed',
      };

      final booking = Booking.fromMap('1', map);

      expect(booking.date, isA<DateTime>());
    });
  });
}
