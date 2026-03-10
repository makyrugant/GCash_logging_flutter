import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()();
  TextColumn get name => text()();
  TextColumn get number => text()();
  TextColumn get amount => text()();
  TextColumn get type => text()();
  TextColumn get fee => text()();
  TextColumn get dscnt => text()();

  // Sync flags
  BoolColumn get isOnline => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();

  DateTimeColumn get dateAdded => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get userSelectedDateAdded =>
      dateTime().withDefault(currentDateAndTime)();

  TextColumn get transactionStatus =>
      text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncMeta extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get lastSyncTimestamp => dateTime().nullable()();
}

@DriftDatabase(tables: [Transactions, SyncMeta])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          // Add columns from v1 to v2
          await m.addColumn(transactions, transactions.dateAdded);
          await m.addColumn(transactions, transactions.userSelectedDateAdded);
        }
        if (from < 3) {
          // Add transactionStatus for v3
          await m.addColumn(transactions, transactions.transactionStatus);
        }
      },
    );
  }

  // Transaction Queries
  Future<List<Transaction>> getAllTransactions() => select(transactions).get();
  Stream<List<Transaction>> watchAllTransactions() =>
      (select(transactions)..orderBy([
            (t) =>
                OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc),
          ]))
          .watch();

  Future<int> insertTransaction(TransactionsCompanion entry) =>
      into(transactions).insert(entry);

  Future updateTransaction(Transaction entry) =>
      update(transactions).replace(entry);

  // Sync Meta Queries
  Future<SyncMetaData?> getSyncMeta() => select(syncMeta).getSingleOrNull();
  Future<int> updateSyncMeta(SyncMetaCompanion entry) =>
      into(syncMeta).insertOnConflictUpdate(entry);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
