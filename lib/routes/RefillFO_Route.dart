import 'package:budgetour/models/CashManager.dart';
import 'package:budgetour/models/Meta/Exceptions/CustomExceptions.dart';
import 'package:budgetour/models/finance_objects/CashOnHand.dart';
import 'package:budgetour/models/finance_objects/FinanceObject.dart';
import 'package:budgetour/models/interfaces/TransactionHistoryMixin.dart';
import 'package:budgetour/pages/EnterTransactionPage.dart';
import 'package:budgetour/widgets/standardized/InfoTile.dart';
import 'package:budgetour/widgets/standardized/MyAppBarView.dart';
import 'package:common_tools/StringFormater.dart';
import 'package:flutter/material.dart';

class RefillObjectPage extends StatelessWidget {
  final FinanceObject financeObj;
  final Function(bool refilled) onRefillComplete;

  RefillObjectPage(this.financeObj, {this.onRefillComplete});

  @override
  Widget build(BuildContext context) {
    return MyAppBarView(
      headerName: financeObj.name,
      stat1: financeObj.getFirstStat(),
      tabPages: [
        Column(
          children: [
            Expanded(
              flex: 1,
              child: InfoTile(
                title: 'Unallocated',
                infoText:
                    '\$ ${Format.formatDouble(CashOnHand.instance.cashAmount, 2)}',
                infoTextColor: Colors.green,
              ),
            ),
            Expanded(
              flex: 12,
              child: EnterTransactionPage(
                onEnterPressed: (amount, _) {
                  try {
                    CashOnHand cashBag = CashOnHand.instance;
                    cashBag.transferToHolder(financeObj, amount);
                    Navigator.of(context).pop();
                  } on PartisanException {
                    print('both parties did not agree');
                  } on InvalidTransferException {
                    print('invalid transfer');
                  }
                },
                headerTitle: 'Refill',
                headerColorAccent: Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}
