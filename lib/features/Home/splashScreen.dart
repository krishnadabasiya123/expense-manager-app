import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoScaleUpAnimation;
  late Animation<double> _logoScaleDownAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _logoAnimationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1500),
          //navigate to anothe screen
        )..addListener(() {
          if (_logoAnimationController.isCompleted) {
            nextScreen();
          }
        });
    _logoScaleUpAnimation = Tween<double>(begin: 0, end: 1.1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0, 0.4, curve: Curves.ease),
      ),
    );
    _logoScaleDownAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: const Interval(0.4, 1, curve: Curves.easeInOut),
      ),
    );

    _logoAnimationController.forward();
  }

  Future<void> nextScreen() async {
    final isLanguageSelect = await Hive.box<dynamic>(settingsBox).get(isLanguageSelected, defaultValue: false) as bool;
    final isCurrencySelect = await Hive.box<dynamic>(settingsBox).get(isCurrencySelected, defaultValue: false) as bool;

    if (isCurrencySelect && isLanguageSelect) {
      await Navigator.of(context).pushReplacementNamed(Routes.bottomNavigationBar);
    } else {
      await Navigator.of(context).pushReplacementNamed(Routes.intro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsivePadding(
        child: Center(
          child: SizedBox(
            width: context.dpWidth(0.8),
            //  color: Colors.amber,
            height: context.dpHeight(0.08),
            child: AnimatedBuilder(
              animation: _logoAnimationController,
              builder: (_, __) => Transform.scale(
                scale: _logoScaleUpAnimation.value - _logoScaleDownAnimation.value,
                child: const QImage(imageUrl: AppImages.splashScreen, fit: BoxFit.contain, fadeInDuration: Duration(milliseconds: 100)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
