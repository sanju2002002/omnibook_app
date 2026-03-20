import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SlotTile extends StatefulWidget {
  final DateTime time;
  final bool isAvailable;
  final bool isSelected;
  final int spots;
  final VoidCallback onTap;

  const SlotTile({
    super.key,
    required this.time,
    required this.isAvailable,
    required this.isSelected,
    required this.spots,
    required this.onTap,
  });

  @override
  State<SlotTile> createState() => _SlotTileState();
}

class _SlotTileState extends State<SlotTile> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat.jm().format(widget.time);

    
    String statusText;
    Color statusColor;

    if (!widget.isAvailable) {
      statusText = "Full";
      statusColor = Colors.redAccent;
    } else if (widget.spots == 1) {
      statusText = "1 left";
      statusColor = Colors.orange;
    } else {
      statusText = "${widget.spots} left";
      statusColor = Colors.greenAccent;
    }

    final isSelected = widget.isSelected;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: widget.isAvailable
            ? () {
                HapticFeedback.selectionClick();
                widget.onTap();
              }
            : null,
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),

          /// 
          transform: Matrix4.identity()
            ..scale(
              isSelected
                  ? 1.06
                  : isPressed
                  ? 0.96
                  : 1.0,
            ),

          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),

          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF8E85FF)],
                  )
                : null,

            color: isSelected
                ? null
                : widget.isAvailable
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.04),

            borderRadius: BorderRadius.circular(18),

            border: Border.all(
              color: isSelected
                  ? Colors.white.withOpacity(0.4)
                  : Colors.white.withOpacity(0.1),
            ),

            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.deepPurple.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 
              Text(
                formattedTime,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : widget.isAvailable
                      ? Colors.white
                      : Colors.white38,
                ),
              ),

              const SizedBox(height: 6),

              /// 
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Container(
                  key: ValueKey(statusText),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withOpacity(0.2)
                        : statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : statusColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
