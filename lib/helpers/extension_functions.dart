import 'dart:convert';
import 'package:intl/intl.dart';

extension IntegerValueChecking on int {
  bool isIntegerEmpty() {
    return this == null || this == 0;
  }
}

extension StringValueParsing on String {
  int toInt() {
    return this == null ? 0 : int.tryParse(this) ?? 0;
  }

  dynamic toImage() {
    return this == null ? null : base64.decode(this);
  }

  String capitalize() {
    return this == null ? "" : "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension StringValueChecking on String {
  bool isStringEmpty() {
    return this?.isEmpty ?? true;
  }
}

extension DateValueParsing on DateTime {
  String convertDateToString() {
    return this == null ? "Empty Date" : "${DateFormat("d/M/yyyy").format(this)}";
  }
}

extension ListChecking on List<dynamic> {
  bool isListEmpty() {
    return this == null || this.length < 1;
  }
}

extension DoubleValueParsing on double {
  String toCurrency() {
    return this == null ? "RM 0.00" : "RM ${this.toStringAsFixed(2)}";
  }
}
