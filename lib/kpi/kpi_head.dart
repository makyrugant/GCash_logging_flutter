import 'package:flutter/material.dart';
import 'package:gcash_logging_android/kpi/kpi_chart.dart';
import 'package:gcash_logging_android/kpi/kpi_row.dart';
import 'package:gcash_logging_android/kpi/kpi_calculator.dart';
import 'package:gcash_logging_android/main.dart';
import 'package:gcash_logging_android/database/database.dart';

class SummaryStatsScreen extends StatelessWidget {
  const SummaryStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Day Report'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: StreamBuilder<List<Transaction>>(
          stream: repository.watchAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data for report'));
            }

            final stats = SummaryStats(snapshot.data!);
            final amtData = stats.amountComparison();
            final feeData = stats.feeComparison();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SummaryKpiRow(stats: stats),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    child: ComparisonBarChart(
                      title: 'Amount Sent vs Received',
                      label1: 'In (Received)',
                      label2: 'Out (Sent)',
                      color1: Colors.blue,
                      color2: Colors.red,
                      items: amtData.entries.map((e) {
                        return (
                          label: e.key,
                          value1: e.value.inAmt,
                          value2: e.value.outAmt,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 300,
                    child: ComparisonBarChart(
                      title: 'Fees: In vs Out',
                      label1: 'In Fees',
                      label2: 'Out Fees',
                      color1: Colors.green,
                      color2: Colors.orange,
                      items: feeData.entries.map((e) {
                        return (
                          label: e.key,
                          value1: e.value.inFee,
                          value2: e.value.outFee,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
