import 'package:flutter_test/flutter_test.dart';
import 'package:community_touring_rwanda/features/tourism/domain/entities/tour_entity.dart';

void main() {
  group('TourEntity', () {
    test('TourEntity constructor creates instance with correct values', () {
      const tour = TourEntity(
        id: '1',
        title: 'Test Tour',
        description: 'Test Description',
        imageUrl: 'test_image',
        duration: '2 Hours',
        priceRwf: 100,
        rating: 4.5,
        category: 'Test',
      );

      expect(tour.id, '1');
      expect(tour.title, 'Test Tour');
      expect(tour.description, 'Test Description');
      expect(tour.imageUrl, 'test_image');
      expect(tour.duration, '2 Hours');
      expect(tour.priceRwf, 100);
      expect(tour.rating, 4.5);
      expect(tour.category, 'Test');
    });

    test('TourEntity constructor uses default values', () {
      const tour = TourEntity(
        id: '1',
        title: 'Test Tour',
        description: 'Test Description',
        imageUrl: 'test_image',
        duration: '2 Hours',
        priceRwf: 100,
      );

      expect(tour.rating, 4.5);
      expect(tour.category, 'Cultural');
    });

    test('TourEntity implements Equatable correctly', () {
      const tour1 = TourEntity(
        id: '1',
        title: 'Test Tour',
        description: 'Test Description',
        imageUrl: 'test_image',
        duration: '2 Hours',
        priceRwf: 100,
        rating: 4.5,
        category: 'Test',
      );

      const tour2 = TourEntity(
        id: '1',
        title: 'Test Tour',
        description: 'Test Description',
        imageUrl: 'test_image',
        duration: '2 Hours',
        priceRwf: 100,
        rating: 4.5,
        category: 'Test',
      );

      const tour3 = TourEntity(
        id: '2',
        title: 'Test Tour',
        description: 'Test Description',
        imageUrl: 'test_image',
        duration: '2 Hours',
        priceRwf: 100,
        rating: 4.5,
        category: 'Test',
      );

      expect(tour1, equals(tour2));
      expect(tour1, isNot(equals(tour3)));
      expect(tour1.props, [
        '1',
        'Test Tour',
        'Test Description',
        'test_image',
        '2 Hours',
        100,
        4.5,
        'Test'
      ]);
    });

    test('TourEntity equality considers all properties', () {
      const tour1 = TourEntity(
        id: '1',
        title: 'Test Tour',
        description: 'Test Description',
        imageUrl: 'test_image',
        duration: '2 Hours',
        priceRwf: 100,
        rating: 4.5,
        category: 'Test',
      );

      const tour2 = TourEntity(
        id: '1',
        title: 'Different Title', // different
        description: 'Test Description',
        imageUrl: 'test_image',
        duration: '2 Hours',
        priceRwf: 100,
        rating: 4.5,
        category: 'Test',
      );

      expect(tour1, isNot(equals(tour2)));
    });
  });
}
