import 'package:flutter_test/flutter_test.dart';
import 'package:community_touring_rwanda/models/tour_model.dart';

void main() {
  group('Tour Model', () {
    test('Tour constructor creates instance with correct values', () {
      const tour = Tour(
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

    test('Tour constructor uses default values', () {
      const tour = Tour(
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

    test('sampleTours contains expected tours', () {
      expect(Tour.sampleTours.length, 4);
      expect(Tour.sampleTours[0].title, 'Cultural Village Tour');
      expect(Tour.sampleTours[1].title, 'Eco-Farm Visit');
      expect(Tour.sampleTours[2].title, 'Mountain Hiking');
      expect(Tour.sampleTours[3].title, 'Lake Kivu Boat Tour');
    });
  });

  group('Guide Model', () {
    test('Guide constructor creates instance with correct values', () {
      const guide = Guide(
        id: '1',
        name: 'Test Guide',
        specialty: 'Test Specialty',
        imageUrl: 'test_image',
        rating: 4.5,
      );

      expect(guide.id, '1');
      expect(guide.name, 'Test Guide');
      expect(guide.specialty, 'Test Specialty');
      expect(guide.imageUrl, 'test_image');
      expect(guide.rating, 4.5);
    });

    test('Guide constructor uses default rating', () {
      const guide = Guide(
        id: '1',
        name: 'Test Guide',
        specialty: 'Test Specialty',
        imageUrl: 'test_image',
      );

      expect(guide.rating, 4.5);
    });

    test('sampleGuides contains expected guides', () {
      expect(Guide.sampleGuides.length, 3);
      expect(Guide.sampleGuides[0].name, 'Eric');
      expect(Guide.sampleGuides[1].name, 'Aline');
      expect(Guide.sampleGuides[2].name, 'Jean');
    });
  });
}
