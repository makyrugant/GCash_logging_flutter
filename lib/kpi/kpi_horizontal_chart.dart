import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TopUsersBarChart extends StatelessWidget {
  final Map<String, double> data;

  const TopUsersBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: SizedBox(
        height: 260,
        child: BarChart(
          BarChartData(
            barGroups: List.generate(entries.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [BarChartRodData(toY: entries[i].value, width: 12)],
              );
            }),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) => Text(
                    entries[v.toInt()].key,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}
