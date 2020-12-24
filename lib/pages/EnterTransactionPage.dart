import '../models/Transaction.dart';
import 'package:budgetour/widgets/standardized/CalculatorView.dart';
import 'package:budgetour/widgets/standardized/EnteredHeader.dart';
import 'package:budgetour/widgets/standardized/EnteredInput.dart';
import 'package:common_tools/ColorGenerator.dart';
import 'package:flutter/material.dart';

class EnterTransactionPage extends StatefulWidget {
  final Function(Transaction transaction) addTransactionFunction;

  EnterTransactionPage(this.addTransactionFunction);

  @override
  _EnterTransactionPageState createState() => _EnterTransactionPageState();
}

class _EnterTransactionPageState extends State<EnterTransactionPage>{
  CalculatorController controller;
  String enteredText;

  _EnterTransactionPageState() {
    this.enteredText = '0.00';
  }

  @override
  void initState() {
    controller = CalculatorController();
    controller.addListener((v) {
      setState(() {
        enteredText = v;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: buildDisplay(),
            ),
          ),
          Flexible(
            flex: 3,
            child: CalculatorView(controller, (entry) {
              widget.addTransactionFunction(Transaction.fillDate(amount: entry));
            })
          ),
        ],
      ),
    );
  }

  // Builds the middle section. ie (not the calculator)
  Widget buildDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          EnteredHeader(
            text: 'Withdraw',
            color: ColorGenerator.fromHex('#FF6868'),
          ),
          EnteredInput('\$ $enteredText'),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Additional Options'),
              Icon(Icons.add_circle_outline),
            ],
          ),
        ],
      ),
    );
  }
}
