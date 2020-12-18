/*
 * When exchanging money from any Finance Object it will be done
 * with a Transaction object.
 */

import 'package:flutter/material.dart';

class Transaction {
  static const String defaultMessage = '*missing note';

  Key key;
  String description;
  double amount;
  TimeOfDay date;

  Transaction(
      {this.description = defaultMessage, @required this.amount, this.date});

  Transaction.fillDate(
      {this.description = defaultMessage, @required this.amount}) {
    this.date = TimeOfDay.now();
  }
}
