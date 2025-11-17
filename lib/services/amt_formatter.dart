import 'package:flutter/services.dart';

class MoneyFormatterNoCents extends TextInputFormatter {
  static const int maxDigits = 5; // 99,999

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Keep digits only
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Prevent entering more than 5 digits
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    // Empty => no value
    if (digits.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Convert to int
    int value = int.parse(digits);

    // Format with commas manually
    final formatted = _formatInt(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _formatInt(int value) {
    final s = value.toString();
    final sb = StringBuffer();
    int count = 0;

    for (int i = s.length - 1; i >= 0; i--) {
      sb.write(s[i]);
      count++;
      if (count == 3 && i != 0) {
        sb.write(',');
        count = 0;
      }
    }

    return sb.toString().split('').reversed.join('');
  }
}
