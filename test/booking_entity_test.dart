import 'package:flutter_test/flutter_test.dart';
import 'package:equatable/equatable.dart';
import 'package:community_touring_rwanda/features/booking/domain/entities/booking_entity.dart';
import 'package:community_touring_rwanda/features/tourism/domain/entities/tour_entity.dart';

void main() {
  group('BookingEntity', () {
    late TourEntity testTour;
    late DateTime testDate;

    setUp(() {
      testTour = const TourEntity(
        id: '1',
        title: 'Test Tour',
        description: 'Test Description',
        imageUrl: 'test_image',
        duration: '2 Hours',
        priceRwf: 100,
        rating: 4.5,
      );
      testDate = DateTime(2024, 3, 27);
    });

    test('BookingEntity constructor creates instance with correct values', () {
      final booking = BookingEntity(
        id: '1',
        tour: TourEntity(
          id: '1',
          title: 'Test Tour',
          description: 'Test Description',
          imageUrl: 'test_image',
          duration: '2 Hours',
          priceRwf: 100,
          rating: 4.5,
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

    test('BookingEntity implements Equatable correctly', () {
      final booking1 = BookingEntity(
        id: '1',
        tour: testTour,
        date: testDate,
        guests: 2,
        totalCost: 200,
        status: 'Confirmed',
        userEmail: 'test@example.com',
      );

      final booking2 = BookingEntity(
        id: '1',
        tour: testTour,
        date: testDate,
        guests: 2,
        totalCost: 200,
        status: 'Confirmed',
        userEmail: 'test@example.com',
      );

      final booking3 = BookingEntity(
        id: '2',
        tour: testTour,
        date: testDate,
        guests: 2,
        totalCost: 200,
        status: 'Confirmed',
        userEmail: 'test@example.com',
      );

      expect(booking1, equals(booking2));
      expect(booking1, isNot(equals(booking3)));
      expect(booking1.props,
          ['1', testTour, testDate, 2, 200, 'Confirmed', 'test@example.com']);
    });

    test('BookingEntity equality considers all properties', () {
      final booking1 = BookingEntity(
        id: '1',
        tour: testTour,
        date: testDate,
        guests: 2,
        totalCost: 200,
        status: 'Confirmed',
        userEmail: 'test@example.com',
      );

      final booking2 = BookingEntity(
        id: '1',
        tour: testTour,
        date: testDate,
        guests: 3, // different
        totalCost: 200,
        status: 'Confirmed',
        userEmail: 'test@example.com',
      );

      expect(booking1, isNot(equals(booking2)));
    });
  });
}
