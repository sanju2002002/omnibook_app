import 'package:flutter/material.dart';
import '../models/service.dart';
import '../models/booking.dart';
import '../data/mock_bookings.dart';

class BookingProvider extends ChangeNotifier {
  final List<Service> _selectedServices = [];
  final List<Booking> _bookings = [...getMockBookings()]; 

  List<Service> get selectedServices => List.unmodifiable(_selectedServices);
  List<Booking> get bookings => List.unmodifiable(_bookings);

  void toggleService(Service service) {
    if (_selectedServices.contains(service)) {
      _selectedServices.remove(service);
    } else {
      _selectedServices.add(service);
    }
    notifyListeners();
  }

  bool isSelected(Service service) {
    return _selectedServices.contains(service);
  }

  int get totalDuration =>
      _selectedServices.fold(0, (sum, s) => sum + s.duration);

  double get totalPrice =>
      _selectedServices.fold(0.0, (sum, s) => sum + s.price);

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void removeBooking(Booking booking) {
    _bookings.removeWhere((b) => b.id == booking.id); 
    notifyListeners();
  }

  void clearSelection() {
    if (_selectedServices.isEmpty) return;
    _selectedServices.clear();
    notifyListeners();
  }

  void resetAll() {
    _selectedServices.clear();
    _bookings
      ..clear()
      ..addAll(getMockBookings()); 
    notifyListeners();
  }
}
