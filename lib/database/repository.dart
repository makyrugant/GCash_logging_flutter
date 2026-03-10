import 'package:drift/drift.dart';
import 'database.dart';

class TransactionRepository {
  final AppDatabase _db;

  TransactionRepository(this._db);

  Stream<List<Transaction>> watchAll() => _db.watchAllTransactions();

  Future<List<Transaction>> getAll() => _db.getAllTransactions();

  Future<int> addTransaction({
    required String id,
    required String date,
    required String name,
    required String number,
    required String amount,
    required String type,
    required String fee,
    required String dscnt,
    DateTime? userSelectedDateAdded,
    String transactionStatus = 'active',
  }) {
    final now = DateTime.now();
    return _db.insertTransaction(
      TransactionsCompanion.insert(
        id: id,
        date: date,
        name: name,
        number: number,
        amount: amount,
        type: type,
        fee: fee,
        dscnt: dscnt,
        updatedAt: now,
        dateAdded: Value(now),
        userSelectedDateAdded: Value(userSelectedDateAdded ?? now),
        isOnline: const Value(false),
        transactionStatus: Value(transactionStatus),
      ),
    );
  }

  Future updateTransaction(Transaction entry) => _db.updateTransaction(entry);

  Future updateTransactionStatus(String id, String newStatus) {
    return (_db.update(_db.transactions)..where((t) => t.id.equals(id))).write(
      TransactionsCompanion(
        transactionStatus: Value(newStatus),
        updatedAt: Value(DateTime.now()),
        isOnline: const Value(false), // Mark dirty for sync
      ),
    );
  }

  // Sync related
  Future<DateTime?> getLastSyncTimestamp() async {
    final meta = await _db.getSyncMeta();
    return meta?.lastSyncTimestamp;
  }

  Future setLastSyncTimestamp(DateTime timestamp) {
    return _db.updateSyncMeta(
      SyncMetaCompanion.insert(
        id: const Value(1),
        lastSyncTimestamp: Value(timestamp),
      ),
    );
  }
}
