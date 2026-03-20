import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/booking_provider.dart';
import '../../data/mock_services.dart';
import '../../models/service.dart';
import '../../widgets/glass_container.dart';
import '../booking/booking_screen.dart';
import '../booking/my_bookings_screen.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🔥 OPTIMIZED SELECTORS
    final selectedServices = context.select<BookingProvider, List<Service>>(
      (p) => p.selectedServices,
    );
    final totalDuration = context.select<BookingProvider, int>(
      (p) => p.totalDuration,
    );
    final totalPrice = context.select<BookingProvider, double>(
      (p) => p.totalPrice,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF8E85FF), Color(0xFF2E2E5E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _header(context),

                /// 🔥 TITLE
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Choose Your Services",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                /// 🔥 SERVICES
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: mockServices.length,
                    itemBuilder: (context, index) {
                      final service = mockServices[index];
                      final isSelected = selectedServices.contains(service);

                      return _ServiceCard(
                        service: service,
                        isSelected: isSelected,
                      );
                    },
                  ),
                ),

                /// 🔥 BOTTOM BAR
                _BottomBar(
                  totalDuration: totalDuration,
                  totalPrice: totalPrice,
                  isEnabled: selectedServices.isNotEmpty,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 HEADER
  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "OmniBook",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calendar_month, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 💎 SERVICE CARD (SEPARATED + CLEAN)
class _ServiceCard extends StatelessWidget {
  final Service service;
  final bool isSelected;

  const _ServiceCard({required this.service, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BookingProvider>();

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        provider.toggleService(service);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF8E85FF)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.4)
                : Colors.white.withOpacity(0.1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.5),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            /// 🔥 ICON (FROM MODEL)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Text(service.icon, style: const TextStyle(fontSize: 18)),
            ),

            const SizedBox(width: 14),

            /// 🔹 TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${service.duration} mins",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 PRICE
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${service.price}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? const Icon(Icons.check_circle, color: Colors.white)
                      : const SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 💎 BOTTOM BAR (SEPARATED)
class _BottomBar extends StatelessWidget {
  final int totalDuration;
  final double totalPrice;
  final bool isEnabled;

  const _BottomBar({
    required this.totalDuration,
    required this.totalPrice,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassContainer(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _info("Duration", "$totalDuration min"),
                _info("Price", "₹$totalPrice"),
              ],
            ),
            const SizedBox(height: 16),

            GestureDetector(
              onTap: isEnabled
                  ? () {
                      HapticFeedback.mediumImpact();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BookingScreen(),
                        ),
                      );
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: isEnabled
                      ? const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF8E85FF)],
                        )
                      : LinearGradient(
                          colors: [Colors.grey.shade500, Colors.grey.shade600],
                        ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  "Continue Booking",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
