import '../../domain/entities/guide_entity.dart';
import '../../domain/entities/tour_entity.dart';
import '../../domain/repositories/tour_repository.dart';

/// Local data source using the sample data from the existing model.
/// In a production app this would fetch from Firestore.
class TourRepositoryImpl implements TourRepository {
  static const List<TourEntity> _tours = [
    TourEntity(
      id: '1',
      title: 'Cultural Village Tour',
      description:
          'Explore traditional Rwandan life.\n\nExperience Rwandan culture with local crafts, dance, and traditional food. Visit authentic villages and learn about centuries-old traditions passed down through generations.',
      imageUrl: 'cultural_village',
      duration: '2 Hours',
      priceRwf: 50,
      rating: 4.8,
      category: 'Cultural',
    ),
    TourEntity(
      id: '2',
      title: 'Eco-Farm Visit',
      description:
          'Visit sustainable farms and learn about organic agriculture in Rwanda.\n\nDiscover how local farmers use traditional and modern techniques to grow crops sustainably.',
      imageUrl: 'eco_farm',
      duration: '3 Hours',
      priceRwf: 40,
      rating: 4.6,
      category: 'Nature',
    ),
    TourEntity(
      id: '3',
      title: 'Mountain Hiking',
      description:
          'Hike through the beautiful Rwandan mountains with experienced guides.\n\nExplore breathtaking trails, discover hidden waterfalls, and enjoy panoramic views of the countryside.',
      imageUrl: 'mountain',
      duration: '5 Hours',
      priceRwf: 80,
      rating: 4.9,
      category: 'Adventure',
    ),
    TourEntity(
      id: '4',
      title: 'Lake Kivu Boat Tour',
      description:
          'Enjoy a scenic boat ride on Lake Kivu with stunning views.\n\nCruise along the shores of one of Africa\'s Great Lakes, visit small islands, and enjoy fresh fish prepared by local fishermen.',
      imageUrl: 'lake_kivu',
      duration: '4 Hours',
      priceRwf: 60,
      rating: 4.7,
      category: 'Nature',
    ),
    TourEntity(
      id: '5',
      title: 'The Pinnacle Boutique Hotel',
      description:
          'Savor world-class cuisine at The Pinnacle Boutique Hotel in Kigali.\n\nIndulge in a curated dining experience featuring the finest Rwandan and international dishes, crafted by top chefs using locally sourced ingredients. Enjoy elegant ambiance, rooftop views of Kigali, and signature cocktails.',
      imageUrl: 'pinnacles',
      duration: '3 Hours',
      priceRwf: 120,
      rating: 4.9,
      category: 'Food',
    ),
  ];

  static const List<GuideEntity> _guides = [
    GuideEntity(
      id: '1',
      name: 'Eric',
      specialty: 'Mountain Guide',
      imageUrl: 'guide_eric',
      rating: 4.9,
    ),
    GuideEntity(
      id: '2',
      name: 'Aline',
      specialty: 'Cultural Expert',
      imageUrl: 'guide_aline',
      rating: 4.8,
    ),
    GuideEntity(
      id: '3',
      name: 'Jean',
      specialty: 'Nature Guide',
      imageUrl: 'guide_jean',
      rating: 4.7,
    ),
  ];

  @override
  Future<List<TourEntity>> getTours() async => _tours;

  @override
  Future<List<GuideEntity>> getGuides() async => _guides;
}
