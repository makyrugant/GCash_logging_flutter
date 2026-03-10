import 'package:flutter/material.dart';
import 'package:gcash_logging_android/main.dart';

class SummaryCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const SummaryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isOnline = data['isOnline'] == true;
    final String status = (data['transactionStatus'] ?? 'active').toLowerCase();
    final bool isActive = status == 'active';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isActive ? Colors.white : Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  data['type'].toString().toLowerCase().contains('in')
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  color: !isActive
                      ? Colors.grey
                      : data['type'].toString().toLowerCase().contains('in')
                      ? Colors.green
                      : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  data['type'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.black87 : Colors.grey,
                    decoration: isActive ? null : TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                if (!isActive) _StatusLabel(status: status),
                const Spacer(),
                _StatusTag(isOnline: isOnline),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) async {
                    await repository.updateTransactionStatus(data['id'], value);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'active', child: Text('Active')),
                    const PopupMenuItem(
                      value: 'cancelled',
                      child: Text('Cancelled'),
                    ),
                    const PopupMenuItem(
                      value: 'returned',
                      child: Text('Returned'),
                    ),
                    const PopupMenuItem(
                      value: 'deleted',
                      child: Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                _gridItem(
                  Icons.calendar_today,
                  'Transaction Date',
                  data['date'],
                ),
                _gridItem(Icons.phone_android, 'Number', data['number']),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _gridItem(Icons.payments, 'Amount', '₱${data['amount']}'),
                _gridItem(Icons.receipt_long, 'Fee', '₱${data['fee']}'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _gridItem(Icons.discount, 'Discount', '₱${data['dscnt']}'),
                _gridItem(Icons.person, 'Name', data['name'] ?? 'N/A'),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  _miniRow(
                    'Recorded on:',
                    data['dateAdded'].toString().split('.')[0],
                  ),
                  _miniRow(
                    'Date Added:',
                    data['userSelectedDateAdded'].toString().split('.')[0],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gridItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 10, color: Colors.black54),
        ),
      ],
    );
  }
}

class _StatusLabel extends StatelessWidget {
  final String status;

  const _StatusLabel({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'cancelled':
        color = Colors.red.shade400;
        break;
      case 'returned':
        color = Colors.orange.shade400;
        break;
      case 'deleted':
        color = Colors.blueGrey.shade400;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final bool isOnline;

  const _StatusTag({required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isOnline ? 'ONLINE' : 'LOCAL',
        style: const TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
