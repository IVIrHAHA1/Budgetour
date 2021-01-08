/*
 * Allows program to interface with all FinaceObjects
 */

import 'package:budgetour/models/finance_objects/LabelObject.dart';
import 'package:budgetour/models/interfaces/TilePresentorMixin.dart';
import 'package:flutter/material.dart';
import '../../widgets/FinanceTile.dart';
import '../../widgets/standardized/MyAppBarView.dart';

/// [FinanceObjectType] allows color schememing in [FinanceTile].
/// Amongst other potential uses.
enum FinanceObjectType {
  budget,
  fixed,
  fund,
  goal,
}

/// with [TilePresenter] allows [FinanceTile] to interface with this behaviour
abstract class FinanceObject with TilePresenter{
  String name;
  final FinanceObjectType _type;
  /// For hints or messages to be displayed above [FinanceTile]
  String affirmation;
  /// Labels to be displayed in [MyAppBarView] or on the face of a [FinanceTile]
  LabelObject label_1, label_2;

  FinanceObject(
    this._type, {
    @required this.name,
    this.label_1,
    this.label_2,
  });

  getType() {
    return _type;
  }
}
