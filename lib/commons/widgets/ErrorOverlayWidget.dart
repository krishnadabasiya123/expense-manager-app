import 'package:expenseapp/core/app/all_import_file.dart';

import 'package:flutter/material.dart';

class ErrorMessageOverlayContainer extends StatefulWidget {
  const ErrorMessageOverlayContainer({required this.errorMessage, required this.backgroundColor, super.key});
  final String errorMessage;
  final Color backgroundColor;

  @override
  State<ErrorMessageOverlayContainer> createState() => _ErrorMessageOverlayContainerState();
}

class _ErrorMessageOverlayContainerState extends State<ErrorMessageOverlayContainer> with SingleTickerProviderStateMixin {
  late AnimationController animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500))..forward();

  late Animation<double> slideAnimation = Tween<double>(begin: -0.5, end: 1).animate(CurvedAnimation(parent: animationController, curve: Curves.easeInOutCirc));

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: errorMessageDisplayDuration.inMilliseconds - 500), () {
      animationController.reverse();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, child) {
        return PositionedDirectional(
          start: MediaQuery.of(context).size.width * 0.05,
          bottom: MediaQuery.of(context).size.height * 0.08 * (slideAnimation.value),
          child: Opacity(
            opacity: slideAnimation.value < 0.0 ? 0.0 : slideAnimation.value,
            child: Material(
              type: MaterialType.transparency,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(color: colorScheme.primary, borderRadius: BorderRadius.circular(10)),
                child: Text(
                  context.tr(widget.errorMessage),
                  style: TextStyle(fontSize: 18.sp(context), color: colorScheme.surface),

                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
