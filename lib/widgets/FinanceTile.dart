import 'package:budgetour/models/finance_objects/BudgetObject.dart';
import 'package:budgetour/models/finance_objects/LabelObject.dart';
import 'package:common_tools/StringFormater.dart';

import '../models/finance_objects/FinanceObject.dart';
import '../tools/GlobalValues.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class FinanceTile extends StatelessWidget {
  final FinanceObject financeObj;

  FinanceTile(this.financeObj);

  @override
  Widget build(BuildContext context) {
    if (financeObj.name == 'Food') print('building food');
    return InkWell(
      onTap: () {
        _openTile(context);
      },
      child: Card(
        color: financeObj.getTileColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlobalValues.roundedEdges),
          side: BorderSide(
              style: BorderStyle.solid,
              width: 1,
              color: ColorGenerator.fromHex(GColors.borderColor)),
        ),
        margin: EdgeInsets.all(8.0),
        child: buildContents(),
      ),
    );
  }

  Column buildContents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Title
        ListTile(
          leading: Text(financeObj.name),
          trailing: Icon(Icons.more_vert),
        ),

        // Label 1
        ListTile(
            title: Text(_getLabelTitle(financeObj.label_1)),
            trailing: _getLabelValues(financeObj.label_1)),

        // Label 2
        ListTile(
            title: Text(_getLabelTitle(financeObj.label_2)),
            trailing: _getLabelValues(financeObj.label_2)),
      ],
    );
  }

  String _getLabelTitle(LabelObject label) {
    if (label != null && label.title != null)
      return label.title;
    else
      return '';
  }

  _getLabelValues(LabelObject label) {
    if (label != null) {
      /// Value has been pre-determined as a constant
      if (!label.hasToEvaluate()) {
        return Text('${Format.formatDouble(label.value, 2)}');
      }

      /// Value needs to be evaluated in the form of a future
      /// *** [Future<double>] is needed as to not slow down
      ///     main UI thread, (Swiping between categories and loading)
      ///     all the financeTiles
      /// Almost works.. when user inputs data it doesn't update
      else {
        return FutureBuilder<double>(
            future: label.evaluateValue,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return Text('${Format.formatDouble(snapshot.data, 2)}');
              } else {
                return Text('error of sort');
              }
            });
      }
    }

    return Text('nothing');
  }

  /// TEST BLOCK::: kinda works, doesnt update however
  /// ---------------------------------------------------------------------------

  Future<double> test(Function fun) async {
    return fun();
  }

  _handlePromisedValue(FinanceObject obj) {
    Function someFun;
    if (obj is BudgetObject) {
      someFun = () {
        return obj.getMonthlyExpenses();
      };

      test(someFun).then((value) {});
    }

    ///dart ```
    /// Future<double> promiseForValue = widget.financeObj.label_1.evaluateValue;
    ///
    /// // Evaluate
    /// if (valueReturned == null && promiseForValue != null) {
    ///   promiseForValue.then((value) {
    ///     setState(() {
    ///       valueReturned = value;
    ///     });
    ///   }, onError: (_) {
    ///     valueReturned = null;
    ///   });
    ///
    ///   return 0;
    /// } else
    ///   return valueReturned;
    /// ```
  }

  /// ---------------------------------------------------------------------------

  _openTile(BuildContext ctx) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (_) {
          return financeObj.getLandingPage();
        },
      ),
    );
  }
}
