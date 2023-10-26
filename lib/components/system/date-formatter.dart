import 'dart:math';

import 'package:flutter/services.dart';

class DateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue prevText, TextEditingValue currText) {
    int selectionIndex;

    // Get the previous and current input strings
    String pText = prevText.text;
    String cText = currText.text;
    // Abbreviate lengths
    int cLen = cText.length;
    int pLen = pText.length;

    if (cLen == 1) {
    } else if (cLen == 2 && pLen == 1) {
      // Month cannot be greater than 21
      int mm = int.parse(cText.substring(0, 2));
      if (mm > 31) {
        // Max char
        cText = '31/';
      } else if (mm < 1) {
        cText = cText.substring(0, 0);
        cText += '01/';
      } else {
        // Add a / char
        cText += '/';
      }
    } else if (cLen == 4) {
    } else if (cLen == 5 && pLen == 4) {
      // Days cannot be greater than 12
      int dd = int.parse(cText.substring(3, 5));
      if (dd > 12) {
        // Remove char
        cText = cText.substring(0, 3);
        cText += '12/';
      } else if (dd < 1) {
        cText = cText.substring(0, 3);
        cText += '01/';
      } else {
        // Add a / char
        cText += '/';
      }
    } else if ((cLen == 2 && pLen == 3) || (cLen == 5 && pLen == 6)) {
      // Wipe / char
      cText = cText.substring(0, cText.length - 1);
    } else if (cLen == 3 && pLen == 2) {
      if (int.parse(cText.substring(2, 3)) > 1) {
        // Replace char
        cText = cText.substring(0, 2) + '/';
      } else {
        // Insert / char
        cText =
            cText.substring(0, pLen) + '/' + cText.substring(pLen, pLen + 1);
      }
    } else if (cLen == 10 && pLen == 9) {
      // Year cannot be greater than current year
      int yer = int.parse(cText.substring(6, 10));
      int currentYear = DateTime.now().year;
      if (yer > currentYear) {
        // Remove char
        cText = cText.substring(0, 6);
        cText += currentYear.toString();
      } else if (yer < 1900) {
        // Remove char
        cText = cText.substring(0, 6);
        cText += '1900';
      }
    }

    selectionIndex = cText.length;
    return TextEditingValue(
      text: cText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

class MaxFormatter extends TextInputFormatter {
  late int maxValue;
  late int padSize;
  MaxFormatter(max, padSize) {
    this.maxValue = max;
    this.padSize = padSize;
  }

  String format(value) {
    String nums = value.replaceAll(RegExp(r'[\D]'), '');
    int? num = int.tryParse(nums);
    if (num == null) return '0'.padLeft(padSize, '0');
    num = max(0, min(maxValue, num));
    return num.toString().padLeft(padSize, '0');
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    String newText = format(text);
    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(
        offset: newText.length,
      ),
    );
  }
}
