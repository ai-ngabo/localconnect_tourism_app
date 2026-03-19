import 'package:equatable/equatable.dart';

class TourEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final int priceRwf;
  final double rating;
  final String category;

  const TourEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.priceRwf,
    this.rating = 4.5,
    this.category = 'Cultural',
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, duration, priceRwf, rating, category];
}
