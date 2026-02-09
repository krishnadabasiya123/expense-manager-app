import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class NormalizeNumber {
  static double inRange({
    required double currentValue,
    required double minValue,
    required double maxValue,
    required double newMinValue,
    required double newMaxValue,
  }) {
    if (maxValue == minValue) return newMinValue;
    final clampedValue = currentValue.clamp(minValue, maxValue);
    return (clampedValue - minValue) * (newMaxValue - newMinValue) / (maxValue - minValue) + newMinValue;
  }
}

/* ===========================
   CUSTOM PAINTERS & STUBS
=========================== */

class FontWeights {
  static const FontWeight bold = FontWeight.bold;
}

extension ColorX on Color {
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withOpacity(alpha);
    }
    return this;
  }
}

class CircleCustomPainter extends CustomPainter {
  CircleCustomPainter({this.color, this.radiusPercentage, this.strokeWidth});
  final Color? color;
  final double? strokeWidth;
  final double? radiusPercentage;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.5);
    final paint = Paint()
      ..strokeWidth = strokeWidth!
      ..color = color!
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, size.width * radiusPercentage!, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ArcCustomPainter extends CustomPainter {
  ArcCustomPainter({required this.sweepAngle, required this.color, required this.radiusPercentage, required this.strokeWidth});
  final double sweepAngle;
  final Color color;
  final double radiusPercentage;
  final double strokeWidth;

  double _degreeToRadian() => -((sweepAngle * pi) / 180.0);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width * 0.5, size.height * 0.5);
    final radius = size.width * radiusPercentage;

    if (sweepAngle >= 359.0) {
      canvas.drawCircle(center, radius, paint);
      return;
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3 * (pi / 2),
      _degreeToRadian(),
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/* ===========================
   RADIAL ARC WIDGET
=========================== */

class RadialPercentageResultContainer extends StatefulWidget {
  const RadialPercentageResultContainer({
    required this.percentage,
    required this.size,
    required this.arcColor,
    required this.circleColor,
    super.key,
    this.circleStrokeWidth = 10.0,
    this.arcStrokeWidth = 10.0,
    this.radiusPercentage = 0.35,
    this.textFontSize = 12,
  });

  final Size size;
  final double percentage;
  final double circleStrokeWidth;
  final double arcStrokeWidth;
  final Color arcColor;
  final Color circleColor;
  final double radiusPercentage;
  final double textFontSize;

  @override
  State<RadialPercentageResultContainer> createState() => _RadialPercentageResultContainerState();
}

class _RadialPercentageResultContainerState extends State<RadialPercentageResultContainer> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  static const double maxMapAngle = 359.9;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    // Initialize animation safely
    animation = Tween<double>(begin: 0, end: 0).animate(animationController);

    _setupAnimation(widget.percentage, isInitial: true);
    animationController.forward();
  }

  void _setupAnimation(double percentage, {bool isInitial = false}) {
    final endAngle = NormalizeNumber.inRange(
      currentValue: percentage,
      minValue: 0,
      maxValue: 100,
      newMaxValue: maxMapAngle,
      newMinValue: 0,
    );

    final beginValue = isInitial ? 0.0 : animation.value;

    animation = Tween<double>(begin: beginValue, end: endAngle).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOut));

    if (!isInitial) {
      animationController.value = 0;
      animationController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant RadialPercentageResultContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage || oldWidget.arcColor != widget.arcColor) {
      _setupAnimation(widget.percentage);
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. Background Circle (Track)
        SizedBox(
          height: widget.size.height,
          width: widget.size.width,
          child: CustomPaint(
            painter: CircleCustomPainter(
              color: widget.circleColor,
              radiusPercentage: widget.radiusPercentage,
              strokeWidth: widget.circleStrokeWidth,
            ),
          ),
        ),

        // 2. Animated Foreground Arc
        SizedBox(
          height: widget.size.height,
          width: widget.size.width,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: ArcCustomPainter(
                  sweepAngle: animation.value,
                  color: widget.arcColor,
                  radiusPercentage: widget.radiusPercentage,
                  strokeWidth: widget.arcStrokeWidth,
                ),
              );
            },
          ),
        ),

        // 3. Percentage Text (Centered on top)
        Text(
          '${widget.percentage.toStringAsFixed(0)}%',
          style: TextStyle(
            fontSize: widget.textFontSize,
            fontWeight: FontWeights.bold,
            fontFamily: GoogleFonts.manrope().fontFamily,
          ),
        ),
      ],
    );
  }
}
