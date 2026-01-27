import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class OverflowMarqueeText extends StatelessWidget {
  const OverflowMarqueeText({
    required this.text,
    required this.style,
    required this.color,
    super.key,
    this.height = 28,
  });
  final String text;
  final TextStyle style;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();

        final isOverflowing = textPainter.width > constraints.maxWidth;

        if (!isOverflowing) {
          return Text(
            text,
            style: style.copyWith(color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        return SizedBox(
          height: height,
          width: constraints.maxWidth,
          child: Marquee(
            text: text,
            style: style.copyWith(color: color),
            blankSpace: 40,
            velocity: 30,
            pauseAfterRound: const Duration(seconds: 1),
            startPadding: 10,
          ),
        );
      },
    );
  }
}
