import 'package:flutter/services.dart';

class GcashNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Keep only digits
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Enforce starting with "09"
    if (!digits.startsWith('09')) {
      digits = '09';
    }

    // Limit to 11 digits total
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    // Apply formatting: 0912 123 1234
    String formatted = _applyFormat(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _applyFormat(String input) {
    if (input.length <= 4) return input; // 0912
    if (input.length <= 7)
      return '${input.substring(0, 4)} ${input.substring(4)}';
    if (input.length <= 11) {
      return '${input.substring(0, 4)} '
          '${input.substring(4, 7)} '
          '${input.substring(7)}';
    }
    return input;
  }
}
