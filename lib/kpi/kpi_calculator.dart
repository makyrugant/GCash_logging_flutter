import 'package:gcash_logging_android/database/database.dart';

class SummaryStats {
  final List<Transaction> all;

  SummaryStats(this.all);

  /// Comparison of amount by date
  Map<String, ({double inAmt, double outAmt})> amountComparison() {
    final result = <String, ({double inAmt, double outAmt})>{};

    for (final item in all) {
      final date = item.date;
      final type = item.type.toLowerCase();
      final amount = double.tryParse(item.amount) ?? 0;

      final current = result[date] ?? (inAmt: 0.0, outAmt: 0.0);
      if (type == 'cash in') {
        result[date] = (inAmt: current.inAmt + amount, outAmt: current.outAmt);
      } else {
        result[date] = (inAmt: current.inAmt, outAmt: current.outAmt + amount);
      }
    }
    return result;
  }

  /// Comparison of fees by date
  Map<String, ({double inFee, double outFee})> feeComparison() {
    final result = <String, ({double inFee, double outFee})>{};

    for (final item in all) {
      final date = item.date;
      final type = item.type.toLowerCase();
      final fee = double.tryParse(item.fee) ?? 0;

      final current = result[date] ?? (inFee: 0.0, outFee: 0.0);
      if (type == 'cash in') {
        result[date] = (inFee: current.inFee + fee, outFee: current.outFee);
      } else {
        result[date] = (inFee: current.inFee, outFee: current.outFee + fee);
      }
    }
    return result;
  }

  double totalFees() =>
      all.fold(0.0, (sum, e) => sum + (double.tryParse(e.fee) ?? 0));

  double totalDiscounts() =>
      all.fold(0.0, (sum, e) => sum + (double.tryParse(e.dscnt) ?? 0));

  double totalCashIn() => all
      .where((e) => e.type.toLowerCase() == 'cash in')
      .fold(0.0, (sum, e) => sum + (double.tryParse(e.amount) ?? 0));

  double totalCashOut() => all
      .where((e) => e.type.toLowerCase() == 'cash out')
      .fold(0.0, (sum, e) => sum + (double.tryParse(e.amount) ?? 0));
}
