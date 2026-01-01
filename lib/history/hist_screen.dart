import 'package:flutter/material.dart';
import 'package:gcash_logging_android/history/hist_card.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SummaryListScreen extends StatelessWidget {
  const SummaryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('summaries').listenable(),
        builder: (_, Box box, __) {
          if (box.isEmpty) {
            return const Center(child: Text('No data'));
          }

          final items = box.values
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
              .reversed
              .toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, i) => SummaryCard(data: items[i]),
          );
        },
      ),
    );
  }
}
