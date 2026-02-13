import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

class NewCustomTextView extends StatelessWidget {
  const NewCustomTextView({
    required this.text,
    super.key,
    this.fontSize,
    this.color,
    this.fontFamily,
    this.textAlign,
    this.maxLines, // Leave this as optional
    this.fontWeight,
    this.softWrap, // Removed default here to handle it in build
    this.overflow,
    this.decoration,
    this.letterspacing,
  });

  final String text;
  final double? fontSize;
  final Color? color;
  final String? fontFamily;
  final TextAlign? textAlign;
  final int? maxLines;
  final FontWeight? fontWeight;
  final bool? softWrap;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterspacing;

  @override
  Widget build(BuildContext context) {
    return Text(
      text, // Put text first for readability
      textAlign: textAlign ?? TextAlign.left,

      // FIX: Removing the "?? 1" allows the text to take
      // as many lines as it needs if maxLines is not provided.
      maxLines: maxLines,

      // FIX: Default to true so it wraps to the next line automatically
      softWrap: softWrap ?? true,

      overflow: overflow ?? TextOverflow.clip,
      style: TextStyle(
        fontSize: fontSize ?? 15.sp(context),
        color: color ?? const Color.fromARGB(255, 0, 0, 0),
        fontWeight: fontWeight,
        decoration: decoration,
        letterSpacing: letterspacing,
        fontFamily: fontFamily,
      ),
    );
  }
}
