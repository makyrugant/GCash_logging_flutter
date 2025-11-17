import 'package:flutter/material.dart';

class CashInSummaryScreen extends StatelessWidget {
  final String date;
  final String accountName;
  final String gcashNumber;
  final String amount;

  const CashInSummaryScreen({
    super.key,
    required this.date,
    required this.accountName,
    required this.gcashNumber,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),

                _buildLabelValue('Date', date),
                const SizedBox(height: 25),

                _buildLabelValue('GCash Account Name', accountName),
                const SizedBox(height: 25),

                _buildLabelValue('GCash Number', gcashNumber),
                const SizedBox(height: 25),

                _buildLabelValue('Amount', "₱ $amount"),
                const SizedBox(height: 35),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
