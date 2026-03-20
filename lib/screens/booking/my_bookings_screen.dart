import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/booking_provider.dart';
import '../../models/booking.dart';
import '../../widgets/glass_container.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🔥 OPTIMIZED (NO FULL REBUILD)
    final bookings = context.select<BookingProvider, List<Booking>>(
      (p) => p.bookings,
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

                /// 🔥 CONTENT
                Expanded(
                  child: bookings.isEmpty
                      ? _emptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: bookings.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            return _bookingCard(context, booking);
                          },
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
              "My Bookings",
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

  /// 🔥 BOOKING CARD
  Widget _bookingCard(BuildContext context, Booking booking) {
    final provider = context.read<BookingProvider>();

    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Counter ${booking.counterId}",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),

              /// 🔥 CANCEL
              GestureDetector(
                onTap: () => _showCancelDialog(context, booking, provider),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.deepOrange],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 TIME
          Row(
            children: [
              const Icon(Icons.schedule, size: 16, color: Colors.white70),
              const SizedBox(width: 6),
              Text(
                "${DateFormat.jm().format(booking.start)} - ${DateFormat.jm().format(booking.end)}",
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// 🔹 SERVICES
          Text(
            "Services",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 8),

          Column(
            children: booking.services.map((service) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.greenAccent,
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        service.name,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),

                    Text(
                      "${service.duration}m",
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      "₹${service.price}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 10),

          /// 🔥 TOTAL (USING MODEL GETTER ✅)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13),
              ),
              Text(
                "₹${booking.totalPrice}",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔥 DIALOG
  void _showCancelDialog(
    BuildContext context,
    Booking booking,
    BookingProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Cancel Booking?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to cancel this booking?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            onPressed: () {
              provider.removeBooking(booking);
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Booking Cancelled")),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  /// 🔥 EMPTY
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 70,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 12),
          Text(
            "No Bookings Yet",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
