import 'package:flutter/material.dart';
import 'package:gcash_logging_android/history/hist_card.dart';
import 'package:gcash_logging_android/main.dart';
import 'package:gcash_logging_android/database/database.dart';

class SummaryListScreen extends StatelessWidget {
  const SummaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: StreamBuilder<List<Transaction>>(
        stream: repository.watchAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data'));
          }

          final items = snapshot.data!;

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => SummaryCard(data: _convertToMap(items[i])),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _convertToMap(Transaction t) {
    return {
      'id': t.id,
      'date': t.date,
      'name': t.name,
      'number': t.number,
      'amount': t.amount,
      'type': t.type,
      'fee': t.fee,
      'dscnt': t.dscnt,
      'isOnline': t.isOnline,
      'dateAdded': t.dateAdded,
      'userSelectedDateAdded': t.userSelectedDateAdded,
      'transactionStatus': t.transactionStatus,
    };
  }
}
