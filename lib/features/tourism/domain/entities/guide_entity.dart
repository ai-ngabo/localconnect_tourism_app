import 'package:equatable/equatable.dart';

class GuideEntity extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;

  const GuideEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    this.rating = 4.5,
  });

  @override
  List<Object?> get props => [id, name, specialty, imageUrl, rating];
}
