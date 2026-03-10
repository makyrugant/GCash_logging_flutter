import 'package:flutter/services.dart';

class GcashRefFormatter extends TextInputFormatter {
  static const int maxDigits = 13; // 4 + 3 + 6

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Digits only
    String digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Limit to 13 digits
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }

    String formatted = _applyFormat(digits);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _applyFormat(String input) {
    if (input.length <= 4) return input; // xxxx
    if (input.length <= 7) {
      // xxxx xxx
      return '${input.substring(0, 4)} ${input.substring(4)}';
    }
    if (input.length <= 13) {
      // xxxx xxx xxxxxx
      return '${input.substring(0, 4)} '
          '${input.substring(4, 7)} '
          '${input.substring(7)}';
    }
    return input;
  }
}
