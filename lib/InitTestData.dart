import 'dart:math';

import 'package:budgetour/models/finance_objects/FixedPaymentObject.dart';

import 'models/Meta/Transaction.dart';
import 'models/finance_objects/BudgetObject.dart';
import 'models/finance_objects/FinanceObject.dart';
import 'models/finance_objects/GoalObject.dart';

class InitTestData {
  static final List<FinanceObject> dummyEssentialList = List<FinanceObject>();

  static initTileList() {
    dummyEssentialList.add(_buildBudgetObjects('Food', 150.99, 10));
    dummyEssentialList.add(_buildBudgetObjects('Gas', 135, 4));
    dummyEssentialList.add(_buildFixedPaymentObject('Rent', 578));

    return dummyEssentialList;
  }

  static BudgetObject _buildBudgetObjects(
      String title, double allocationAmount, int transactionQTY) {
    BudgetObject obj;
    // Create budget object
    if (title == 'Food') {
      obj = BudgetObject(
        title: title,
        allocatedAmount: allocationAmount,
        stat1: BudgetStat.allocated,
        stat2: BudgetStat.remaining,
      );
    } else {
      obj = BudgetObject(
        title: title,
        allocatedAmount: allocationAmount,
        stat1: BudgetStat.allocated,
        stat2: BudgetStat.spent,
      );
    }

    // Log random transactions
    for (int i = 0; i <= transactionQTY; i++) {
      obj.logTransaction(
        Transaction(
          description: 'Tran_${i + 1}',
          amount: _doubleInRange(5, 25),
          date: DateTime.now().subtract(Duration(days: i * 3)),
        ),
      );
    }

    return obj;
  }

  // Eventually have history, labels and due dates
  static FixedPaymentObject _buildFixedPaymentObject(
      String title, double amount) {
    FixedPaymentObject obj = FixedPaymentObject(
      name: title,
      monthlyFixedPayment: amount,
    );

    obj.firstStat = FixedPaymentStats.nextDue;
    obj.secondStat = FixedPaymentStats.nextDue;
    return obj;
  }

  static GoalObject _buildGoalObject(
    String name,
    double targetAmount, {
    double fixedAmount,
    double percentage,
    DateTime date,
  }) {
    if (fixedAmount != null) {
      return GoalObject(
        targetAmount,
        name: name,
        contributeByFixedAmount: fixedAmount,
      );
    } else if (percentage != null) {
      return GoalObject(
        targetAmount,
        name: name,
        contributeByPercent: percentage,
      );
    } else if (date != null) {
      return GoalObject(
        targetAmount,
        name: name,
        completeByDate: date,
      );
    }
  }

  static double _doubleInRange(num start, num end) =>
      Random().nextDouble() * (end - start) + start;
}
