import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnibook_app/models/booking.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/service.dart';

import '../../providers/booking_provider.dart';
import '../../services/slot_services.dart';
import '../../widgets/slot_tile.dart';
import '../../widgets/glass_container.dart';
import '../summary/summary_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedSlot;

  @override
  Widget build(BuildContext context) {
    /// 
    final duration = context.select<BookingProvider, int>(
      (p) => p.totalDuration,
    );
    final price = context.select<BookingProvider, double>((p) => p.totalPrice);
    final bookings = context.select<BookingProvider, List<Booking>>(
      (p) => p.bookings,
    );
    final services = context.read<BookingProvider>().selectedServices;

    final slots = SlotService.generateSlots();

    /// 
    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width > 600 ? 4 : 3;

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
                ///  HEADER
                _header(context),

                /// 🔹 INFO
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _glassChip(icon: Icons.schedule, label: "$duration mins"),
                      _glassChip(icon: Icons.currency_rupee, label: "₹$price"),
                    ],
                  ),
                ),

                /// 🔹 GRID
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: slots.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.4,
                      ),
                      itemBuilder: (context, index) {
                        final slot = slots[index];

                        final isAvailable = SlotService.isSlotAvailable(
                          slotStart: slot,
                          duration: duration,
                          bookings: bookings,
                        );

                        final spots = isAvailable
                            ? SlotService.availableCounters(
                                slotStart: slot,
                                duration: duration,
                                bookings: bookings,
                              )
                            : 0;

                        return AnimatedScale(
                          scale: selectedSlot == slot ? 1.05 : 1,
                          duration: const Duration(milliseconds: 200),
                          child: SlotTile(
                            time: slot,
                            isAvailable: isAvailable,
                            isSelected: selectedSlot == slot,
                            spots: spots,
                            onTap: () {
                              if (!isAvailable) return;

                              HapticFeedback.selectionClick();

                              setState(() => selectedSlot = slot);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                ///  BOTTOM BAR
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: selectedSlot == null
                      ? const SizedBox.shrink()
                      : _bottomBar(context, duration, bookings, services),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///  HEADER
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
            const Text(
              "Select Time Slot",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 CHIP
  Widget _glassChip({required IconData icon, required String label}) {
    return GlassContainer(
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  ///  BOTTOM BAR
  Widget _bottomBar(
    BuildContext context,
    int duration,
    List<Booking> bookings,
    List<Service> services,
  ) {
    final endTime = selectedSlot!.add(Duration(minutes: duration));

    final counter = SlotService.getAvailableCounter(
      slotStart: selectedSlot!,
      duration: duration,
      bookings: bookings,
    );

    final isEnabled = counter != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.jm().format(selectedSlot!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat.jm().format(endTime),
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ///  BUTTON
            GestureDetector(
              onTap: isEnabled
                  ? () {
                      HapticFeedback.mediumImpact();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SummaryScreen(
                            services: List.from(services),
                            startTime: selectedSlot!,
                            endTime: endTime,
                            counter: counter!,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Container(
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
                child: const Text(
                  "Confirm Slot",
                  style: TextStyle(
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
}
