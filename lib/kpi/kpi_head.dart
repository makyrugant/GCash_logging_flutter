import 'package:flutter/material.dart';
import 'package:gcash_logging_android/kpi/kpi_chart.dart';
import 'package:gcash_logging_android/kpi/kpi_horizontal_chart.dart';
import 'package:gcash_logging_android/kpi/kpi_row.dart';
import 'package:gcash_logging_android/services/kpi_calculator.dart';

class SummaryStatsScreen extends StatelessWidget {
  const SummaryStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = SummaryStats();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SummaryKpiRow(stats: stats),
              const SizedBox(height: 12),

              SizedBox(
                height: 260,
                child: DailyTotalBarChart(data: stats.totalByDate()),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 280,
                child: TopUsersBarChart(data: stats.totalByUser()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
