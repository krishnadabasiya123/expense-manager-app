import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextView extends StatelessWidget {
  const CustomTextView({
    required this.text,
    super.key,
    this.fontSize,
    this.color,
    this.fontFamily,
    this.textAlign,
    this.maxLines,
    this.fontWeight,
    this.softWrap = false,
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
      textAlign: textAlign ?? TextAlign.left,
      maxLines: maxLines ?? 1,
      text,
      softWrap: softWrap ?? false,
      overflow: overflow ?? TextOverflow.clip,
      style: TextStyle(
        fontSize: fontSize ?? 15.sp(context),
        color: color ?? const Color.fromARGB(255, 0, 0, 0),
        fontWeight: fontWeight,
        decoration: decoration,
        letterSpacing: letterspacing,
      ),
    );
  }
}
