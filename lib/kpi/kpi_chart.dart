import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

class DailyTotalBarChart extends StatelessWidget {
  final Map<String, double> data;

  const DailyTotalBarChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.toList();

    return Card(
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            barGroups: List.generate(entries.length, (i) {
              return BarChartGroupData(
                x: i,
                barRods: [BarChartRodData(toY: entries[i].value, width: 14)],
              );
            }),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (v, _) => Text(
                    entries[v.toInt()].key,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
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
