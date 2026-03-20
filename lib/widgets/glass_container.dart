import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;

  /// 
  final double blur;
  final double borderRadius;
  final EdgeInsets padding;
  final Color color;
  final double borderOpacity;
  final bool enableShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 15,
    this.borderRadius = 24,
    this.padding = const EdgeInsets.all(16),
    this.color = const Color.fromRGBO(255, 255, 255, 0.08),
    this.borderOpacity = 0.2,
    this.enableShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      // 
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(borderRadius),

              /// 
              border: Border.all(
                color: Colors.white.withOpacity(borderOpacity),
                width: 1,
              ),

              /// 
              boxShadow: enableShadow
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
