class Tour {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final int priceRwf;
  final double rating;
  final String category;

  const Tour({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.priceRwf,
    this.rating = 4.5,
    this.category = 'Cultural',
  });

  static List<Tour> sampleTours = [
    const Tour(
      id: '1',
      title: 'Cultural Village Tour',
      description:
          'Explore traditional Rwandan life.\n\nExperience Rwandan culture with local crafts, dance, and traditional food. Visit authentic villages and learn about centuries-old traditions passed down through generations. Meet local artisans, taste traditional cuisine, and participate in cultural activities.',
      imageUrl: 'cultural_village',
      duration: '2 Hours',
      priceRwf: 50,
      rating: 4.8,
      category: 'Cultural',
    ),
    const Tour(
      id: '2',
      title: 'Eco-Farm Visit',
      description:
          'Visit sustainable farms and learn about organic agriculture in Rwanda.\n\nDiscover how local farmers use traditional and modern techniques to grow crops sustainably. Participate in farming activities, learn about permaculture, and enjoy fresh farm-to-table meals.',
      imageUrl: 'eco_farm',
      duration: '3 Hours',
      priceRwf: 40,
      rating: 4.6,
      category: 'Nature',
    ),
    const Tour(
      id: '3',
      title: 'Mountain Hiking',
      description:
          'Hike through the beautiful Rwandan mountains with experienced guides.\n\nExplore breathtaking trails, discover hidden waterfalls, and enjoy panoramic views of the countryside. Our experienced mountain guides will ensure a safe and memorable adventure.',
      imageUrl: 'mountain',
      duration: '5 Hours',
      priceRwf: 80,
      rating: 4.9,
      category: 'Adventure',
    ),
    const Tour(
      id: '4',
      title: 'Lake Kivu Boat Tour',
      description:
          'Enjoy a scenic boat ride on Lake Kivu with stunning views.\n\nCruise along the shores of one of Africa\'s Great Lakes, visit small islands, and enjoy fresh fish prepared by local fishermen. Watch the sunset over the lake for an unforgettable experience.',
      imageUrl: 'lake_kivu',
      duration: '4 Hours',
      priceRwf: 60,
      rating: 4.7,
      category: 'Nature',
    ),
  ];
}

class Guide {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;

  const Guide({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    this.rating = 4.5,
  });

  static List<Guide> sampleGuides = [
    const Guide(
      id: '1',
      name: 'Eric',
      specialty: 'Mountain Guide',
      imageUrl: 'guide_eric',
      rating: 4.9,
    ),
    const Guide(
      id: '2',
      name: 'Aline',
      specialty: 'Cultural Expert',
      imageUrl: 'guide_aline',
      rating: 4.8,
    ),
    const Guide(
      id: '3',
      name: 'Jean',
      specialty: 'Nature Guide',
      imageUrl: 'guide_jean',
      rating: 4.7,
    ),
  ];
}

class Booking {
  final String id;
  final Tour tour;
  final DateTime date;
  final int guests;
  final int totalCost;
  final String status; // 'Confirmed', 'Completed', 'Cancelled'
  final String? userEmail;

  const Booking({
    required this.id,
    required this.tour,
    required this.date,
    required this.guests,
    required this.totalCost,
    required this.status,
    this.userEmail,
  });

  static List<Booking> sampleBookings = [];
}
