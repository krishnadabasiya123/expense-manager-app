import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:flutter/material.dart';

class IntrosliderScreen extends StatefulWidget {
  const IntrosliderScreen({super.key});

  @override
  State<IntrosliderScreen> createState() => _IntrosliderScreenState();
}

class _IntrosliderScreenState extends State<IntrosliderScreen> {
  List<Map<String, dynamic>> introSliderContent = [
    {'image': AppImages.intro1, 'title': 'Track Your Spending habits with Account!', 'subtitle': 'Enter your daily transactions to gain powerful insights into your spending habits'},
    {'image': AppImages.intro2, 'title': 'Plan Your Budget', 'subtitle': 'Set budgets for categories and achieve your savings goals.'},
  ];

  final ValueNotifier<int> _currentPage = ValueNotifier(0);
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _currentPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: ResponsivePadding(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.8,
              width: size.width,
              child: ValueListenableBuilder(
                valueListenable: _currentPage,
                builder: (context, value, child) {
                  return PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      _currentPage.value = index;
                    },
                    itemCount: introSliderContent.length,
                    itemBuilder: (context, index) {
                      final item = introSliderContent[index];
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image takes ~60% height
                              SizedBox(
                                height: constraints.maxHeight * 0.5,
                                width: constraints.maxWidth,
                                child: Image.asset(item['image'] as String, width: constraints.maxWidth),
                              ),

                              // Text takes ~35% height
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomTextView(
                                    text: item['title'] as String,
                                    fontSize: 28,
                                    color: colorScheme.onTertiary,

                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomTextView(text: item['subtitle'] as String, fontSize: 18, color: colorScheme.onTertiary, textAlign: TextAlign.center, maxLines: 2),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(child: _buildBottomMenu()),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomMenu() {
    return ValueListenableBuilder(
      valueListenable: _currentPage,
      builder: (context, value, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: (_currentPage.value == 0)
                  ? const SizedBox()
                  : Align(
                      alignment: Alignment.bottomLeft,
                      child: GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(_currentPage.value - 1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.2)),
                          ),
                          margin: const EdgeInsetsDirectional.only(bottom: 15),
                          child: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.surface),
                        ),
                      ),
                    ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,

                child: Container(
                  margin: const EdgeInsetsDirectional.only(bottom: 35),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(introSliderContent.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        margin: const EdgeInsetsDirectional.symmetric(horizontal: 4),
                        width: _currentPage.value == index ? 8 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage.value == index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () async {
                    if (introSliderContent.length - 1 != _currentPage.value) {
                      _pageController.animateToPage(_currentPage.value + 1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                    } else {
                      final isLanguageSelect = await Hive.box<dynamic>(settingsBox).get(isLanguageSelected, defaultValue: false) as bool;
                      final isCurrencySelect = await Hive.box<dynamic>(settingsBox).get(isCurrencySelected, defaultValue: false) as bool;

                      if (isCurrencySelect && isLanguageSelect) {
                        await Navigator.of(context).pushReplacementNamed(Routes.bottomNavigationBar);
                      } else {
                        await Navigator.of(context).pushReplacementNamed(Routes.selectLanguage);
                      }
                      // Navigator.of(context).pushNamed(Routes.selectLanguage);
                    }
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(color: Theme.of(context).colorScheme.onTertiary.withValues(alpha: 0.2)),
                    ),
                    margin: const EdgeInsetsDirectional.only(bottom: 15),
                    child: Icon(Icons.arrow_forward, color: Theme.of(context).colorScheme.surface),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
