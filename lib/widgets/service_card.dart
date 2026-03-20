import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/service.dart';

class ServiceCard extends StatefulWidget {
  final Service service;
  final bool isSelected;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onTap();
        },
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),

          
          transform: Matrix4.identity()
            ..scale(
              isSelected
                  ? 1.04
                  : isPressed
                  ? 0.97
                  : 1.0,
            ),

          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF8E85FF)],
                  )
                : null,
            color: isSelected
                ? null
                : Colors.white.withOpacity(0.08), // 

            borderRadius: BorderRadius.circular(22),

            border: Border.all(
              color: isSelected
                  ? Colors.white.withOpacity(0.4)
                  : Colors.white.withOpacity(0.1),
            ),

            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? Colors.deepPurple.withOpacity(0.4)
                    : Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: Row(
            children: [
              _buildIcon(isSelected),
              const SizedBox(width: 14),
              _buildText(isSelected),
              _buildPrice(isSelected),
            ],
          ),
        ),
      ),
    );
  }

  /// 
  Widget _buildIcon(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? Colors.white.withOpacity(0.2)
            : Colors.white.withOpacity(0.1),
      ),
      child: Text(
        widget.service.icon ?? "✂️", // 
        style: const TextStyle(fontSize: 18),
      ),
    );
  }

  /// 
  Widget _buildText(bool isSelected) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.service.name,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                "${widget.service.duration} mins",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 
  Widget _buildPrice(bool isSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "₹${widget.service.price}",
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: isSelected
              ? const Icon(
                  Icons.check_circle_rounded,
                  key: ValueKey("check"),
                  color: Colors.white,
                  size: 22,
                )
              : const SizedBox(key: ValueKey("empty"), height: 22),
        ),
      ],
    );
  }
}
