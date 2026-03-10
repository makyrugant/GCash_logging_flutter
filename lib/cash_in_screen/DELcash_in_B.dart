// import 'package:flutter/material.dart';

// class CashInSummaryScreen extends StatelessWidget {
//   final String date;
//   final String accountName;
//   final String gcashNumber;
//   final String amount;

//   const CashInSummaryScreen({
//     super.key,
//     required this.date,
//     required this.accountName,
//     required this.gcashNumber,
//     required this.amount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Summary')),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20),
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 100.0),
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Card(
//                     elevation: 0,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                       side: const BorderSide(color: Colors.black12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 20,
//                         horizontal: 16,
//                       ),
//                       child: Column(
//                         children: [
//                           _buildLabelValue('Date', date),
//                           _buildLabelValue('GCash Account Name', accountName),
//                           _buildLabelValue('GCash Number', gcashNumber),
//                           _buildLabelValue('Amount', '₱ $amount'),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   SizedBox(
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Confirm'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLabelValue(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         const SizedBox(height: 16),
//         Text(
//           value,
//           style: const TextStyle(fontSize: 20),
//           textAlign: TextAlign.center,
//         ),
//         const Divider(),

//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.blue[900],
//           ),
//           textAlign: TextAlign.center,
//         ),

//         const SizedBox(height: 6),
//       ],
//     );
//   }
// }
