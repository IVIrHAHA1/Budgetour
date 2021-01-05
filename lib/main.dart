import 'package:budgetour/InitTestData.dart';
import 'package:budgetour/Widgets/FinanceTile.dart';
import 'package:budgetour/models/CategoryListManager.dart';
import 'package:budgetour/pages/CreateBillPage.dart';
import 'package:budgetour/pages/CreateBudgetPage.dart';
import 'package:budgetour/pages/MenuListPage.dart';
import 'package:budgetour/widgets/standardized/InfoTile.dart';
import 'package:flutter/foundation.dart';
import 'models/finance_objects/FinanceObject.dart';
import 'package:flutter/material.dart';
import 'package:common_tools/ColorGenerator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primaryColor: ColorGenerator.createMaterialColor('000000'),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline5: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  final CategoryListManager manager = CategoryListManager.instance;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(
      initialIndex: 0,
      length: 5,
      vsync: this,
    );
    InitTestData.initTileList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 10);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.unfold_more),
            title: Text('macro'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.unfold_less),
            title: Text('micro'),
          )
        ],
      ),
      appBar: AppBar(
        title: ListTile(
          // Category Info 1
          leading: Text('Allocated'),

          // Add Finance Object Button
          title: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) {
                    return buildCreateFinanceObjectMenu(context);
                  },
                ),
              );
            },
            child: Icon(
              Icons.add_circle_outline,
              size: 32,
            ),
          ),

          // Category Info 2
          trailing: Text('Pending'),
        ),

        // Create Category Tabs
        bottom: TabBar(
          controller: _controller,
          tabs: CategoryType.values.map((e) {
            // Use Enums for titles
            String label = e.toString().split('.').last;
            return Text(label, style: style);
          }).toList(),
        ),
      ),

      // Build Body
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: InfoTile(
                title: 'Unallocated',
                infoText: '\$ 100',
              ),
            ),
            Expanded(
              flex: 12,
              child: TabBarView(
                controller: _controller,
                children: [
                  TileLayout(widget.manager.essentials),
                  TileLayout(widget.manager.securities),
                  TileLayout(widget.manager.goals),
                  TileLayout(widget.manager.lifestyle),
                  TileLayout(widget.manager.misc),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  MenuListPage buildCreateFinanceObjectMenu(BuildContext context) {
    /// [_controller.index] gets the tab name of the TabBarView. Which
    /// is correlated with the [CategoryType] enum list
    return MenuListPage({
      Text('Budget', style: Theme.of(context).textTheme.headline5): () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return CreateBudgetPage(CategoryType.values[_controller.index]);
            },
          ),
        );
      },
      Text(
        'Bill',
        style: Theme.of(context).textTheme.headline5,
      ): () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return CreateBillPage(CategoryType.values[_controller.index]);
            },
          ),
        );
      },
      Text(
        'Goal',
        style: Theme.of(context).textTheme.headline5,
      ): () {
        print('create goal');
      },
      Text(
        'Fund',
        style: Theme.of(context).textTheme.headline5,
      ): () {
        print('create fund');
      },
      Text(
        'Investment',
        style: Theme.of(context).textTheme.headline5,
      ): () {
        print('create investment');
      },
    });
  }
}

class TileLayout extends StatelessWidget {
  final List<FinanceObject> financeList;

  TileLayout(this.financeList);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: financeList.length != 0
          ? GridView.count(
              crossAxisCount: 2,
              children: financeList.map((element) {
                return FinanceTile(element);
              }).toList(),
            )
          : Center(child: Text('Nothing to display')),
    );
  }
}
