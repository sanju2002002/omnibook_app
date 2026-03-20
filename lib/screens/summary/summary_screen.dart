import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/service.dart';
import '../../models/booking.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/glass_container.dart';

class SummaryScreen extends StatelessWidget {
  final List<Service> services;
  final DateTime startTime;
  final DateTime endTime;
  final int counter;

  const SummaryScreen({
    super.key,
    required this.services,
    required this.startTime,
    required this.endTime,
    required this.counter,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.jm();

    /// 🔥 CREATE TEMP BOOKING (USE MODEL POWER)
    final tempBooking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      counterId: counter,
      start: startTime,
      end: endTime,
      services: services,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF8E85FF), Color(0xFF2E2E5E)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _header(context),

                /// 🔥 CONTENT
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Column(
                      children: [
                        _glassCard(
                          "Services",
                          Column(
                            children: services.map((s) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      size: 18,
                                      color: Colors.greenAccent,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        s.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "₹${s.price}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 12),

                        _glassCard(
                          "Time",
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                timeFormat.format(startTime),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              Text(
                                timeFormat.format(endTime),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        _glassCard(
                          "Counter",
                          Text(
                            "Counter $counter",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// 🔥 SUMMARY (USING MODEL)
                        _glassCard(
                          "Summary",
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${tempBooking.totalDuration} mins",
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                "₹${tempBooking.totalPrice}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        /// 🔥 BUTTON
                        _confirmButton(context, tempBooking),
                      ],
                    ),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 60,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            Text(
              "Booking Summary",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 BUTTON
  Widget _confirmButton(BuildContext context, Booking booking) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();

        final provider = Provider.of<BookingProvider>(context, listen: false);

        provider.addBooking(booking);
        provider.clearSelection();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Booking Confirmed 🎉"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.popUntil(context, (route) => route.isFirst);
      },
      child: Container(
        height: 54,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF8E85FF)],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          "Confirm Booking",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  /// 🔥 CARD
  Widget _glassCard(String title, Widget child) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
