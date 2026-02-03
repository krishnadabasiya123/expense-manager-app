import 'package:expenseapp/core/app/all_import_file.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PieChartPage extends StatefulWidget {
  const PieChartPage({super.key});

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int touchedIndex = -1;
  int selectedChart = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
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
        title: Text('Pie Charts', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.orange.shade50, Colors.white]),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Chart selector

              // Chart area
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
                          _buildChartTitle(),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(flex: 3, child: _buildSelectedChart()),
                                // const SizedBox(width: 20),
                                //Expanded(flex: 2, child: _buildLegend()),
                              ],
                            ),
                          ),
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

  Widget _buildChartTitle() {
    final titles = ['Market Share Analysis', 'Monthly Expenses', 'Website Traffic Sources'];
    final subtitles = ['Distribution by competitors', 'Breakdown by categories', 'User acquisition channels'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titles[selectedChart],
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
        Text(subtitles[selectedChart], style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildSelectedChart() {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 4,
        centerSpaceRadius: 60,
        sections: _getExpensesSections(),
        startDegreeOffset: -90 * _animation.value,
      ),
    );
  }

  Color _generateAccountColor(String key) {
    final hash = key.hashCode.abs();

    final hue = hash % 360; // 0–360
    const saturation = 65; // %
    const lightness = 55; // %

    return HSLColor.fromAHSL(
      1,
      hue.toDouble(),
      saturation / 100,
      lightness / 100,
    ).toColor();
  }

  List<PieChartSectionData> _getExpensesSections() {
    final data = context.read<GetAccountCubit>().getAccounts();

    return data.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final animatedValue = (data[index].amount / 100) * _animation.value;

      return PieChartSectionData(
        color: _generateAccountColor(data[index].id),
        value: animatedValue,
        title: '${animatedValue.toStringAsFixed(1)}%',
        radius: radius,
        titleStyle: GoogleFonts.poppins(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 36, 35, 35)),
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2))],
                ),
                child: Text(
                  item.name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        badgePositionPercentageOffset: 1.3,
      );
    }).toList();
  }

  Widget _buildLegend() {
    final legends = [
      [
        {'label': 'Our App', 'color': Colors.blue.shade600, 'value': '35%'},
        {'label': 'Competitor A', 'color': Colors.red.shade600, 'value': '25%'},
        {'label': 'Competitor B', 'color': context.colorScheme.incomeColor, 'value': '20%'},
        {'label': 'Competitor C', 'color': Colors.orange.shade600, 'value': '12%'},
        {'label': 'Others', 'color': Colors.purple.shade600, 'value': '8%'},
      ],
      [
        {'label': 'Salaries', 'color': Colors.red.shade600, 'value': '30%'},
        {'label': 'Marketing', 'color': Colors.blue.shade600, 'value': '25%'},
        {'label': 'Development', 'color': context.colorScheme.incomeColor, 'value': '20%'},
        {'label': 'Operations', 'color': Colors.orange.shade600, 'value': '15%'},
        {'label': 'Other', 'color': Colors.purple.shade600, 'value': '10%'},
      ],
      [
        {'label': 'Organic Search', 'color': Colors.blue.shade600, 'value': '40%'},
        {'label': 'Social Media', 'color': context.colorScheme.incomeColor, 'value': '25%'},
        {'label': 'Direct', 'color': Colors.orange.shade600, 'value': '20%'},
        {'label': 'Paid Ads', 'color': Colors.red.shade600, 'value': '10%'},
        {'label': 'Email', 'color': Colors.purple.shade600, 'value': '5%'},
      ],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Legend',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: legends[selectedChart].length,
            itemBuilder: (context, index) {
              final item = legends[selectedChart][index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(color: item['color']! as Color, borderRadius: BorderRadius.circular(8)),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['label']! as String,
                            style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade800),
                          ),
                          Text(item['value']! as String, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
