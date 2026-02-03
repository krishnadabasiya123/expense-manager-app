import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:expenseapp/features/RecurringTransaction/Cubit/get_recurring_transaction_cubit.dart';
import 'package:expenseapp/features/RecurringTransaction/Model/Recurring.dart';
import 'package:expenseapp/features/Statistics/Screen/bar_chart_page.dart';
import 'package:expenseapp/features/Statistics/Screen/chart_card.dart';
import 'package:expenseapp/features/Statistics/Screen/line_chart_page.dart';
import 'package:expenseapp/features/Statistics/Screen/pie_chart_page.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// // ---------------- MAIN WIDGET ----------------
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with TickerProviderStateMixin {
  late List<double> data;
  late double maxAmount;
  late double maxY;
  late double interval;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    data = context.read<GetAccountCubit>().getAccountAmountList();
    maxAmount = context.read<GetAccountCubit>().getMaxAmount();
    maxY = getChartMaxY(maxAmount);
    interval = getInterval(maxY);
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));
    _animationController.forward();
  }

  Future<void> clearMyBox() async {
    await Hive.deleteFromDisk();
    setState(() {});
  }

  int touchedIndex = -1;
  late AnimationController _animationController;
  late Animation<double> _animation;

  double getChartMaxY(double max) {
    if (max <= 10) return 10;
    if (max <= 100) return 100;
    if (max <= 500) return 500;
    if (max <= 1000) return 1000;
    if (max <= 5000) return 5000;
    return ((max / 1000).ceil()) * 1000;
  }

  double getInterval(double maxY) {
    if (maxY <= 100) return 10;
    if (maxY <= 500) return 50;
    if (maxY <= 1000) return 100;
    if (maxY <= 5000) return 500;
    return 1000;
  }

  List<BarChartGroupData> _getRevenueBarGroups(double maxY) {
    final data = context.read<GetAccountCubit>().getAccountAmountList();
    log('data $data');
    final colors = [Colors.blue.shade600, context.colorScheme.incomeColor, Colors.orange.shade600, Colors.purple.shade600, Colors.red.shade600, Colors.teal.shade600];

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value * _animation.value;
      final isTouched = index == touchedIndex;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value,
            color: colors[index],
            width: isTouched ? 25 : 20,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxY, color: colors[index].withValues(alpha: 0.1)),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildRevenueChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 7000,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            // color: Colors.black87,
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final categories = ['Mobile', 'Web', 'Desktop', 'API', 'Cloud', 'Test'];
              return BarTooltipItem('${categories[group.x]}\n\$${rod.toY.round()}K', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
            },
          ),
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            // touch type is drag , on tap , long press
            setState(() {
              if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
        ),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                final categories = context.read<GetAccountCubit>().getAccountNameList();
                final style = TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 12);
                if (value.toInt() >= 0 && value.toInt() < categories.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(categories[value.toInt()], style: style),
                  );
                }
                return const Text('');
              },
              reservedSize: 36,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: 1000,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value >= 1000) {
                  return Text(
                    '${(value / 1000).toStringAsFixed(0)}K',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _getRevenueBarGroups(maxY),
        gridData: FlGridData(
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
          },
        ),
      ),
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Center(
          child: Text('Statistics', style: TextStyle(color: Colors.white)),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
              clearMyBox();
            },
            icon: const Icon(Icons.calendar_month_sharp, color: Colors.white),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Beautiful Charts',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                          ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                      ),
                    ),

                    Text('Powered by FL Chart 🚀', style: GoogleFonts.poppins(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
                    const SizedBox(height: 40),
                    Expanded(child: GridView.count(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85, children: _buildChartCards())),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToPage(Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  List<Widget> _buildChartCards() {
    final cards = [
      ChartCard(
        title: 'Bar Charts',
        subtitle: 'Dynamic & Animated',
        icon: Icons.bar_chart,
        colors: [context.colorScheme.incomeColor, context.colorScheme.incomeColor],
        onTap: () => _navigateToPage(const BarChartPage()),
        delay: 100,
      ),
      ChartCard(
        title: 'Pie Charts',
        subtitle: 'Colorful & Engaging',
        icon: Icons.pie_chart,
        colors: [Colors.orange.shade400, Colors.orange.shade600],
        onTap: () => _navigateToPage(const PieChartPage()),
        delay: 200,
      ),
      ChartCard(
        title: 'Line Charts',
        subtitle: 'Colorful & Engaging',
        icon: Icons.pie_chart,
        colors: [Colors.orange.shade400, Colors.teal.shade600],
        onTap: () => _navigateToPage(const LineChartPage()),
        delay: 200,
      ),
    ];

    return cards;
  }
}
