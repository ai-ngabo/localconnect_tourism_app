class TourModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final double price;
  final String currency;
  final int durationHours;
  final String providerId;
  final double rating;

  const TourModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.price,
    required this.currency,
    required this.durationHours,
    required this.providerId,
    required this.rating,
  });
}

class GuideModel {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final String bio;

  const GuideModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.bio,
  });
}

// Sample data
final List<TourModel> sampleTours = [
  TourModel(
    id: '1',
    title: 'Cultural Village Tour',
    description: 'Explore traditional Rwandan life.',
    imageUrl: 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?w=600',
    category: 'Cultural',
    price: 50,
    currency: 'Rwf',
    durationHours: 2,
    providerId: '1',
    rating: 4.8,
  ),
  TourModel(
    id: '2',
    title: 'Eco-Farm Visit',
    description: 'Experience sustainable farming in Rwanda.',
    imageUrl: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600',
    category: 'Nature',
    price: 75,
    currency: 'Rwf',
    durationHours: 3,
    providerId: '2',
    rating: 4.6,
  ),
  TourModel(
    id: '3',
    title: 'Mountain Trek',
    description: 'Hike through the beautiful Rwandan highlands.',
    imageUrl: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=600',
    category: 'Adventure',
    price: 120,
    currency: 'Rwf',
    durationHours: 5,
    providerId: '1',
    rating: 4.9,
  ),
  TourModel(
    id: '4',
    title: 'Lake Kivu Boat Tour',
    description: 'Sail across the stunning Lake Kivu.',
    imageUrl: 'https://images.unsplash.com/photo-1502101872923-d48509bff386?w=600',
    category: 'Water',
    price: 90,
    currency: 'Rwf',
    durationHours: 4,
    providerId: '2',
    rating: 4.7,
  ),
];

final List<GuideModel> sampleGuides = [
  GuideModel(
    id: '1',
    name: 'Eric',
    specialty: 'Mountain guide',
    imageUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300',
    rating: 4.9,
    bio: 'Eric has over 10 years of experience guiding tourists through Rwanda\'s beautiful mountains and national parks.',
  ),
  GuideModel(
    id: '2',
    name: 'Alikne',
    specialty: 'Cultural Expert',
    imageUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300',
    rating: 4.8,
    bio: 'Alikne is a passionate cultural ambassador who brings Rwandan traditions to life through immersive experiences.',
  ),
  GuideModel(
    id: '3',
    name: 'Marie',
    specialty: 'Eco-Tourism',
    imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300',
    rating: 4.7,
    bio: 'Marie specializes in sustainable eco-tourism experiences that connect visitors with nature.',
  ),
];

const List<String> tourCategories = [
  'All',
  'Cultural',
  'Nature',
  'Adventure',
  'Water',
];