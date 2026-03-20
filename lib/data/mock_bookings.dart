import '../models/booking.dart';
import '../models/service.dart';

/// 
List<Booking> getMockBookings() {
  final now = DateTime.now();

  return [
    Booking(
      id: "b1",
      counterId: 1,
      start: DateTime(now.year, now.month, now.day, 10, 0),
      end: DateTime(now.year, now.month, now.day, 11, 0),
      services: const [
        Service(
          id: "s1",
          name: "Haircut",
          duration: 30,
          price: 150,
          icon: "💇‍♂️",
        ),
        Service(
          id: "s2",
          name: "Beard Trim",
          duration: 15,
          price: 80,
          icon: "🧔",
        ),
      ],
    ),

    Booking(
      id: "b2",
      counterId: 2,
      start: DateTime(now.year, now.month, now.day, 10, 30),
      end: DateTime(now.year, now.month, now.day, 11, 30),
      services: const [
        Service(
          id: "s3",
          name: "Hair Spa",
          duration: 45,
          price: 300,
          icon: "🧴",
        ),
      ],
    ),

    Booking(
      id: "b3",
      counterId: 3,
      start: DateTime(now.year, now.month, now.day, 9, 0),
      end: DateTime(now.year, now.month, now.day, 10, 30),
      services: const [
        Service(
          id: "s4",
          name: "Haircut",
          duration: 30,
          price: 150,
          icon: "✂️",
        ),
        Service(id: "s5", name: "Facial", duration: 40, price: 250, icon: "✨"),
      ],
    ),
  ];
}
