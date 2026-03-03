import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wordstock/model/models.dart';
import 'package:wordstock/repositories/quiz_repository.dart';

/// Loads and displays a line chart of the user's quiz score % over the
/// last 14 days.
class PracticeHistoryChart extends StatefulWidget {
  const PracticeHistoryChart({super.key});

  @override
  State<PracticeHistoryChart> createState() => _PracticeHistoryChartState();
}

class _PracticeHistoryChartState extends State<PracticeHistoryChart> {
  late final Future<List<PracticeSession>> _future;

  @override
  void initState() {
    super.initState();
    _future = QuizRepository().getPracticeHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PracticeSession>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 180,
            child: Center(
              child: CircularProgressIndicator(color: Color(0xffE94E77)),
            ),
          );
        }

        final sessions = snapshot.data ?? [];

        if (sessions.isEmpty) {
          return Container(
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F7F7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xffEEEEEE)),
            ),
            child: const Text(
              'Complete a quiz to see your history here',
              style: TextStyle(color: Colors.black45, fontSize: 14),
            ),
          );
        }

        // Build one data point per session (up to last 14 days)
        final spots = <FlSpot>[];
        for (var i = 0; i < sessions.length; i++) {
          spots.add(FlSpot(i.toDouble(), sessions[i].scorePercent));
        }

        final avgScore = sessions.isEmpty
            ? 0.0
            : sessions
                    .map((s) => s.scorePercent)
                    .reduce((a, b) => a + b) /
                sessions.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatChip(
                  label: 'Sessions',
                  value: '${sessions.length}',
                  color: const Color(0xff1CB0F6),
                ),
                _StatChip(
                  label: 'Avg score',
                  value: '${avgScore.round()}%',
                  color: const Color(0xff58CC02),
                ),
                _StatChip(
                  label: 'Best',
                  value: '${sessions.map((s) => s.scorePercent).reduce(
                        (a, b) => a > b ? a : b,
                      ).round()}%',
                  color: const Color(0xffFFC800),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    horizontalInterval: 25,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: Color(0xffEEEEEE),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 25,
                        reservedSize: 32,
                        getTitlesWidget: (value, meta) => Text(
                          '${value.toInt()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: sessions.length <= 7,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= sessions.length) {
                            return const SizedBox.shrink();
                          }
                          final date = sessions[idx].completedAt;
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${date.month}/${date.day}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black38,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                  ),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: const Color(0xffE94E77),
                      barWidth: 2.5,
                      dotData: FlDotData(
                        getDotPainter: (spot, percent, bar, index) =>
                            FlDotCirclePainter(
                          radius: 4,
                          color: const Color(0xffE94E77),
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xffE94E77).withAlpha(25),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
