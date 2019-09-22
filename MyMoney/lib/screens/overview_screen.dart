import 'package:flutter/material.dart';
import 'package:my_money/screens/new_expense_screen.dart';
import 'package:my_money/screens/total_expense_screen.dart';
import 'package:my_money/engine/engine.dart';
import 'package:my_money/engine/quotes.dart';
import 'popup_screens.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

double wkSpent = 0;
double budget;
double hrs;
double rate;
double pct;
double cardBalance = 1234.00;
double cashBalance = 9999.00;

class _OverviewScreenState extends State<Overview> {
  @override
  void initState() {
    super.initState();
    db.getLastWeek();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
      color: Colors.grey[350],
      child: PageView(
        controller: PageController(initialPage: 1),
        children: <Widget>[
          TotalExpenseScreen(),
          Center(
              child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(
                      bottom: 10,
                      top: 30,
                    ),
                    child: textConstruct(
                        'Finances Overview', Colors.black, true, 33)),
                Container(
                  padding: EdgeInsets.only(
                    bottom: 10,
                    top: 25,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        alignment: Alignment(0.0, 0.0),
                        height: 100,
                        width: 150,
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 20,
                        ),
                        child: Column(
                          children: <Widget>[
                            textConstruct(
                                '\n\$${cardBalance.toStringAsFixed(2)}',
                                Colors.blueGrey,
                                true,
                                20),
                            textConstruct(
                                'Card Balance', Colors.black, false, 15),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white),
                      ),
                      Container(
                        alignment: Alignment(0.0, 0.0),
                        height: 100,
                        width: 150,
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 20,
                        ),
                        child: Column(
                          children: <Widget>[
                            textConstruct(
                                '\n\$${cashBalance.toStringAsFixed(2)}',
                                Colors.green[800],
                                true,
                                20),
                            textConstruct(
                                'Cash Balance', Colors.black, false, 15),
                          ],
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment(0.0, 0.0),
                  height: 100,
                  width: 150,
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Column(
                    children: <Widget>[
                      textConstruct('\n\$${budget.toStringAsFixed(2)}',
                          remainderAdjust(budget), true, 20),
                      textConstruct(
                          'Remaining Budget', Colors.black, false, 15),
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.grey),
                ),
                Container(
                    alignment: Alignment(0.0, 0.0),
                    height: 150,
                    width: 300,
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: textConstruct(getQuote(), Colors.black, false, 17)),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: 150,
                      child: RaisedButton(
                        color: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_box, size: 40),
                              Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 5,
                                  ),
                                  child: textConstruct('Add Expense',
                                      Colors.yellow[300], true, 20)),
                            ]),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return ExpenseScreen(
                              backgroundStatus: 1,
                            );
                          }));
                        },
                      ),
                    ),
                    Container(
                        height: 150,
                        width: 150,
                        child: RaisedButton(
                          color: Colors.grey[600],
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.monetization_on, size: 40),
                                Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                    child: textConstruct('Edit Your Budget',
                                        Colors.teal[100], true, 20)),
                              ]),
                          onPressed: () async {
                            //You need to activate this before release
                            await updateBudgetPrefs();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BudgetDialog(
                                      hrs: hrs, rate: rate, pct: pct);
                                });
                          },
                        ))
                  ],
                )
              ],
            ),
          )),
          //  BalanceScreen()
        ],
      ),
    ));
  }
}
