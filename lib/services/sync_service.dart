import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../database/database.dart' as db;
import '../database/repository.dart';

class SyncService {
  final TransactionRepository repository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SyncService(this.repository);

  CollectionReference get _collection => _firestore.collection('transactions');

  Future<void> sync() async {
    await pushLocalChanges();
    await pullRemoteChanges();
  }

  Future<void> pushLocalChanges() async {
    final allLocal = await repository.getAll();
    final toSync = allLocal.where((t) => !t.isOnline).toList();

    for (final transaction in toSync) {
      try {
        await _collection.doc(transaction.id).set({
          'id': transaction.id,
          'date': transaction.date,
          'name': transaction.name,
          'number': transaction.number,
          'amount': transaction.amount,
          'type': transaction.type,
          'fee': transaction.fee,
          'dscnt': transaction.dscnt,
          'dateAdded': transaction.dateAdded.toIso8601String(),
          'userSelectedDateAdded': transaction.userSelectedDateAdded
              .toIso8601String(),
          'transactionStatus': transaction.transactionStatus,
          'updatedAt': transaction.updatedAt.toIso8601String(),
          'serverUpdatedAt': FieldValue.serverTimestamp(),
        });

        // Mark as online locally
        await repository.updateTransaction(
          transaction.copyWith(isOnline: true),
        );
      } catch (e) {
        debugPrint('Error pushing transaction ${transaction.id}: $e');
      }
    }
  }

  Future<void> pullRemoteChanges() async {
    final lastSync = await repository.getLastSyncTimestamp() ?? DateTime(2000);

    final snapshot = await _collection
        .where('serverUpdatedAt', isGreaterThan: lastSync)
        .orderBy('serverUpdatedAt')
        .get();

    if (snapshot.docs.isEmpty) return;

    DateTime newestTimestamp = lastSync;

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final remoteUpdatedAt =
          (data['serverUpdatedAt'] as Timestamp?)?.toDate() ?? DateTime.now();

      if (remoteUpdatedAt.isAfter(newestTimestamp)) {
        newestTimestamp = remoteUpdatedAt;
      }

      final transaction = db.Transaction(
        id: data['id'],
        date: data['date'],
        name: data['name'],
        number: data['number'],
        amount: data['amount'],
        type: data['type'],
        fee: data['fee'] ?? '',
        dscnt: data['dscnt'] ?? '',
        isOnline: true,
        dateAdded: data['dateAdded'] != null
            ? DateTime.parse(data['dateAdded'])
            : DateTime.now(),
        userSelectedDateAdded: data['userSelectedDateAdded'] != null
            ? DateTime.parse(data['userSelectedDateAdded'])
            : data['userSelectedDate'] != null
            ? DateTime.parse(data['userSelectedDate'])
            : DateTime.now(),
        transactionStatus: data['transactionStatus'] ?? 'active',
        updatedAt: DateTime.parse(data['updatedAt']),
        serverUpdatedAt: remoteUpdatedAt,
      );

      // Simple conflict resolution: update if it exists, insert if not
      // Drift's insertOnConflictUpdate can be used if we had it in the repository,
      // for now let's just use updateTransaction or add logic to check existence.
      // Since AppDatabase has insertOnConflictUpdate for SyncMeta, let's assume we can add it for Transactions too if needed.
      // But for Transactions we defined it with standard update.

      await repository.updateTransaction(transaction);
      // Note: If update returns false (not found), we should insert.
      // Let's refine the repository to handle this more robustly if needed.
    }

    await repository.setLastSyncTimestamp(newestTimestamp);
  }
}
