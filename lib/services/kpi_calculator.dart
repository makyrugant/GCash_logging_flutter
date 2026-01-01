import 'package:hive/hive.dart';

class SummaryStats {
  final Box box = Hive.box('summaries');

  List<Map<String, dynamic>> get all =>
      box.values.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();

  /// Total per date (cashin - cashout)
  Map<String, double> totalByDate() {
    final Map<String, double> result = {};

    for (final item in all) {
      final date = item['date'];
      final type = item['type'];
      final amount = double.tryParse(item['amount']) ?? 0;

      result.putIfAbsent(date, () => 0);
      result[date] = result[date]! + (type == 'cashin' ? amount : -amount);
    }

    return result;
  }

  /// Total per user (top users)
  Map<String, double> totalByUser() {
    final Map<String, double> result = {};

    for (final item in all) {
      final name = item['name'];
      final type = item['type'];
      final amount = double.tryParse(item['amount']) ?? 0;

      result.putIfAbsent(name, () => 0);
      result[name] = result[name]! + (type == 'cashin' ? amount : -amount);
    }

    return result;
  }

  double totalCashIn() => all
      .where((e) => e['type'] == 'cashin')
      .fold(0, (sum, e) => sum + (double.tryParse(e['amount']) ?? 0));

  double totalCashOut() => all
      .where((e) => e['type'] == 'cashout')
      .fold(0, (sum, e) => sum + (double.tryParse(e['amount']) ?? 0));
}
