class Service {
  final String id; 
  final String name;
  final int duration;
  final double price;
  final String icon; 
  const Service({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.icon,
  });

  /// 
  Service copyWith({
    String? id,
    String? name,
    int? duration,
    double? price,
    String? icon,
  }) {
    return Service(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      icon: icon ?? this.icon,
    );
  }

  /// 
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
