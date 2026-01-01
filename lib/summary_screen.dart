import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class SummaryScreen extends StatelessWidget {
  final String date;
  final String name;
  final String number;
  final String amount;
  final String type;

  const SummaryScreen({
    super.key,
    required this.date,
    required this.name,
    required this.number,
    required this.amount,
    required this.type,
  });
  // Future<void> uploadPendingSummaries() async {
  //   final box = Hive.box('summaries');

  //   for (int i = 0; i < box.length; i++) {
  //     final data = Map<String, dynamic>.from(box.getAt(i));

  //     if (data['isOnline'] == true) continue;

  //     await FirebaseFirestore.instance
  //         .collection('summaries')
  //         .doc(data['id']) // critical
  //         .set({
  //           ...data,
  //           'isOnline': true,
  //           'updatedAt': FieldValue.serverTimestamp(),
  //         });

  //     data['isOnline'] = true;
  //     await box.putAt(i, data);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summary')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 100.0,
              left: 100,
              right: 100,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 16,
                      ),
                      child: Column(
                        children: [
                          _buildLabelValue('Date', date),
                          _buildLabelValue('GCash Account Name', name),
                          _buildLabelValue('GCash Number', number),
                          _buildLabelValue('Amount', '₱ $amount'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Expanded(
                      //   child: ElevatedButton(
                      //     onPressed: () => Navigator.pop(context),
                      //     child: const Text('Cancel'),
                      //   ),
                      // ),
                      // const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Print'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await Hive.box('summaries').add(
                              buildSummaryMap(
                                id: const Uuid().v4(),
                                date: date,
                                name: name,
                                number: number,
                                amount: amount,
                                type: type,
                                isOnline: false,
                                updatedAt: DateTime.now().toIso8601String(),
                              ),
                            );

                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> buildSummaryMap({
    required String id,
    required String date,
    required String name,
    required String number,
    required String amount,
    required String type,
    required bool isOnline,
    required String updatedAt,
  }) {
    return {
      'id': id,
      'date': date,
      'name': name,
      'number': number,
      'amount': amount,
      'type': type,

      // shared flags
      'isOnline': isOnline,
      'updatedAt': updatedAt,
    };
  }

  Widget _buildLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 16),
        Text(
          value,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
        const Divider(),

        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.blue[900],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
