import 'package:flutter/material.dart';
import 'package:gcash_logging_android/services/kpi_calculator.dart';

class SummaryKpiRow extends StatelessWidget {
  final SummaryStats stats;

  const SummaryKpiRow({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _kpi('Cash In', stats.totalCashIn()),
        _kpi('Cash Out', stats.totalCashOut()),
        _kpi('Net', stats.totalCashIn() - stats.totalCashOut()),
      ],
    );
  }

  Widget _kpi(String title, double value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                value.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
