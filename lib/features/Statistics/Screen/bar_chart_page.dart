import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BarChartPage extends StatefulWidget {
  const BarChartPage({super.key});

  @override
  State<BarChartPage> createState() => _BarChartPageState();
}

class _BarChartPageState extends State<BarChartPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int selectedChart = 0;
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.bounceOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bar Charts', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [context.colorScheme.incomeColor, Colors.white]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Chart selector
              Expanded(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildRevenueChart()),
                          const SizedBox(height: 20),
                          _buildLegend(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            // color: Colors.black87,
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final categories = UiUtils.month;
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
                final categories = UiUtils.month;
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
              interval: 20,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  '\$${value.toInt()}K',
                  style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 12),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _getRevenueBarGroups(),
        gridData: FlGridData(
          horizontalInterval: 20,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> _getRevenueBarGroups() {
    final data = context.read<GetTransactionCubit>().getMonthlyIncomeExpenseOnly();
    // final expense = data.map((e) => e['expense']).toList();

    // Your datasets
    // final data1 = [85.0, 72.0, 65.0, 58.0, 92.0];
    // final data2 = [30.0, 20.0, 10.0, 5.0, 2.0];

    final data1 = [85.0, 72.0, 65.0, 58.0, 92.0];
    final data2 = [30.0, 20.0, 10.0, 5.0, 2.0];

    // Colors for each dataset
    final colors1 = [
      Colors.blue.shade600,
      context.colorScheme.incomeColor,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.red.shade600,
    ];
    final colors2 = [
      Colors.blue.shade400,
      context.colorScheme.incomeColor,
      Colors.orange.shade400,
      Colors.purple.shade400,
      Colors.red.shade400,
    ];

    return data2.asMap().entries.map((entry) {
      final index = entry.key;
      final value1 = data1[index] * _animation.value;
      final value2 = data2[index] * _animation.value;
      final isTouched = index == touchedIndex;

      return BarChartGroupData(
        x: index,
        barsSpace: 0, // space between the two bars in the same group
        barRods: [
          // First bar
          BarChartRodData(
            toY: value1,
            color: colors1[index],
            width: isTouched ? 25 : 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100, // you can replace this with dynamic maxY
              color: colors1[index].withValues(alpha: 0.1),
            ),
          ),
          // Second bar
          BarChartRodData(
            toY: value2,
            color: colors2[index],
            width: isTouched ? 25 : 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100, // you can replace this with dynamic maxY
              color: colors2[index].withValues(alpha: 0.1),
            ),
          ),
        ],
      );
    }).toList();
  }

  Widget _buildLegend() {
    final legends = [
      [
        'Mobile',
        'Web',
        'Desktop',
        'API',
        'Cloud',
      ],
      ['iOS', 'Android', 'Windows', 'macOS'],
      ['Sales', 'Marketing', 'Development', 'Support'],
    ];
    final colors = [
      [Colors.blue.shade600, context.colorScheme.incomeColor, Colors.orange.shade600, Colors.purple.shade600, Colors.red.shade600],
      [Colors.blue.shade600, context.colorScheme.incomeColor, Colors.orange.shade600, Colors.purple.shade600],
      [Colors.blue.shade600, context.colorScheme.incomeColor, Colors.orange.shade600, Colors.purple.shade600],
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: legends[selectedChart].asMap().entries.map((entry) {
        final index = entry.key;
        final label = entry.value;
        final color = colors[selectedChart][index];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
            ),
          ],
        );
      }).toList(),
    );
  }
}
