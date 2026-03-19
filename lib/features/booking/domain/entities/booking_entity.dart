import 'package:equatable/equatable.dart';

import '../../../tourism/domain/entities/tour_entity.dart';

class BookingEntity extends Equatable {
  final String id;
  final TourEntity tour;
  final DateTime date;
  final int guests;
  final int totalCost;
  final String status; // 'Confirmed', 'Completed', 'Cancelled'
  final String? userEmail;

  const BookingEntity({
    required this.id,
    required this.tour,
    required this.date,
    required this.guests,
    required this.totalCost,
    required this.status,
    this.userEmail,
  });

  @override
  List<Object?> get props => [id, tour, date, guests, totalCost, status, userEmail];
}
