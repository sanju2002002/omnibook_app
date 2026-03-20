class Service {
  final String id; // 🔥 IMPORTANT
  final String name;
  final int duration;
  final double price;
  final String icon; // 🔥 UI improvement

  const Service({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.icon,
  });

  /// 🔥 COPY WITH (SCALABLE)
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

  /// 🔥 EQUALITY (VERY IMPORTANT FOR PROVIDER)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Service && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
