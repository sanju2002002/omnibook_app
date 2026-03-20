import 'service.dart';

class Booking {
  final String id; 
  final int counterId;
  final DateTime start;
  final DateTime end;
  final List<Service> services;
  final DateTime createdAt;

  Booking({
    required this.id,
    required this.counterId,
    required this.start,
    required this.end,
    required this.services,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// 
  double get totalPrice => services.fold(0.0, (sum, s) => sum + s.price);

  /// 
  int get totalDuration => services.fold(0, (sum, s) => sum + s.duration);

  /// 
  Booking copyWith({
    String? id,
    int? counterId,
    DateTime? start,
    DateTime? end,
    List<Service>? services,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      counterId: counterId ?? this.counterId,
      start: start ?? this.start,
      end: end ?? this.end,
      services: services ?? this.services,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
