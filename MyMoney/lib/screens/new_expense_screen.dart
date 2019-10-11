import 'package:my_money/screens/overview_screen.dart';

import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_money/engine/engine.dart';
import 'package:my_money/engine/entry.dart';

import 'package:my_money/screens/total_expense_screen.dart';

class ExpenseScreen extends StatefulWidget {
  //backgroundstatus = 0 comes from lockscreen, 1 comes from button
  final int backgroundStatus;

  ExpenseScreen({this.backgroundStatus});
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  //goes to the overview screen
  void unlock() {}

  String selection = '';
  Color color1 = Colors.indigo[100];
  Color color2 = Colors.indigo[200];
  Color color3 = Colors.indigo[300];
  String select1 = '';
  String select2 = '';
  bool hasError = false;
  Color col1 = Colors.black;
  Color col2 = Colors.black;

  Color srcCol1 = Color.fromARGB(255, 141, 118, 179);
  Color srcCol2 = Color.fromARGB(255, 217, 135, 80);

  int amtValidator = 1;
  int nameValidator = 1;
  int sourceValidator = 1;

  //stuff for the entry itself
  int choice = -1;
  double amt;
  String name;
  String tags;

  String type = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Track New Interaction'),
          backgroundColor: Color.fromARGB(255, 55, 90, 120),
        ),
        body: Container(
            child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child:
              //rest of your code write here
              SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ButtonBar(alignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                    ),
                    child: ButtonTheme(
                        minWidth: 50.0,
                        height: 50.0,
                        child: RaisedButton(
                          child: Text('Withdrawal'),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: color1,
                          splashColor: Colors.greenAccent,
                          onPressed: () {
                            setState(() {
                              color1 = Colors.indigo[100];
                              color2 = Colors.grey;
                              color3 = Colors.grey;
                              selection = 'Withdrawal';
                              nameValidator = 0;
                              sourceValidator = 0;
                              col2 = Colors.black;
                            });
                          },
                        )),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        top: 5,
                      ),
                      child: ButtonTheme(
                          minWidth: 50.0,
                          height: 50.0,
                          child: RaisedButton(
                            child: Text('Expense'),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            color: color2,
                            splashColor: Colors.greenAccent,
                            onPressed: () {
                              setState(() {
                                color1 = Colors.grey;
                                color2 = Colors.indigo[200];
                                color3 = Colors.grey;
                                selection = 'Expense';
                                select1 = 'Cash';
                                select2 = 'Card';
                              });
                            },
                          ))),
                  Padding(
                      padding: EdgeInsets.only(
                        top: 5,
                      ),
                      child: ButtonTheme(
                          minWidth: 50.0,
                          height: 50.0,
                          child: RaisedButton(
                            child: Text('Deposit'),
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            color: color3,
                            splashColor: Colors.greenAccent,
                            onPressed: () {
                              setState(() {
                                color1 = Colors.grey;
                                color2 = Colors.grey;
                                color3 = Colors.indigo[300];
                                selection = 'Deposit';
                                select1 = 'Adding to cash';
                                select2 = 'Deposit to bank';
                              });
                            },
                          ))),
                ]),

                Padding(
                    padding: EdgeInsets.only(
                      left: 40,
                      top: 10,
                      right: 40,
                      bottom: 10,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: 'AMOUNT',
                          labelStyle: TextStyle(
                            color: col1,
                            fontWeight: FontWeight.bold,
                          )),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onChanged: (text) {
                        if (!regex.hasMatch(text)) {
                          setState(() {
                            amtValidator = 1;
                            col1 = Colors.red;
                            hasError = true;
                          });
                        } else {
                          setState(() {
                            amtValidator = 0;
                            col1 = Colors.black;
                            amt = double.parse(text);
                          });
                        }
                      },
                    )),

                //Name
                Padding(
                  padding: EdgeInsets.only(
                    left: 40,
                    top: 10,
                    right: 40,
                    bottom: 10,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                          color: col2,
                        )),
                    onChanged: (text) {
                      setState(() {
                        nameValidator = 0;
                        col2 = Colors.black;
                        name = text;
                      });
                    },
                  ),
                ),

                //Tags
                Padding(
                    padding: EdgeInsets.only(
                      left: 40,
                      top: 10,
                      right: 40,
                      bottom: 10,
                    ),
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Tags'),
                      onChanged: (text) {
                        tags = text;
                      },
                    )),
                //Source
                Visibility(
                    child: ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(select1),
                          color: srcCol1,
                          onPressed: () {
                            setState(() {
                              choice = 0;
                              sourceValidator = 0;
                              srcCol2 = Color.fromARGB(75, 217, 135, 80);
                              srcCol1 = Color.fromARGB(255, 141, 118, 179);
                            });
                          },
                        ),
                        RaisedButton(
                          child: Text(select2),
                          color: srcCol2,
                          onPressed: () {
                            setState(() {
                              choice = 1;
                              sourceValidator = 0;
                              srcCol1 = Color.fromARGB(75, 141, 118, 179);
                              srcCol2 = Color.fromARGB(255, 217, 135, 80);
                            });
                          },
                        ),
                      ],
                    ),
                    visible: selection == 'Deposit' || selection == 'Expense'),
                Visibility(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 40,
                        top: 0,
                        right: 40,
                        bottom: 10,
                      ),
                      child: Text(
                        'Please fill in all mandatory fields',
                        style: TextStyle(color: Colors.red, fontSize: 15),
                      ),
                    ),
                    visible: hasError),
                //Submit
                Padding(
                  padding: EdgeInsets.only(
                    top: (hasError == true) ? 0 : 10,
                  ),
                  child: ButtonTheme(
                    minWidth: 200.0,
                    height: 70.0,
                    child: RaisedButton(
                      child: Text(
                        'Submit $selection',
                        style: TextStyle(color: Colors.black),
                      ),
                      color: Colors.lime,
                      onPressed: () async {
                        if (sourceValidator + amtValidator + nameValidator ==
                            0) {
                          setState(() {
                            hasError = false;
                          });

                          switch (selection) {
                            case 'Withdrawal':
                              {
                                //Subtract from card
                                setState(() {
                                  cardBalance = cardBalance - amt;
                                  setDouble('cardBalance', cardBalance);
                                });

                                type = 'Withdrawal';
                              }
                              break;

                            case 'Expense':
                              {
                                //subtract from card or cash
                                setState(() {
                                  if (choice == 0) {
                                    cashBalance = cashBalance - amt;
                                    setDouble('cashBalance', cashBalance);
                                    type = 'Cash Expense';
                                  } else {
                                    cardBalance = cardBalance - amt;
                                    setDouble('cardBalance', cardBalance);
                                    type = 'Card Expense';
                                  }
                                  budget = budget - amt;
                                  setDouble('budget', budget);
                                });

                                //create entry
                              }
                              break;

                            case 'Deposit':
                              {
                                //card or cash
                                setState(() {
                                  if (choice == 0) {
                                    cashBalance = cashBalance + amt;
                                    setDouble('cashBalance', cashBalance);
                                    type = 'Cash Deposit';
                                  } else {
                                    cardBalance = cardBalance + amt;
                                    setDouble('cardBalance', cardBalance);
                                    type = 'Card Deposit';
                                  }
                                });

                                //create entry
                              }
                              break;
                            default:
                              print(
                                  'NEW EXPENSE ERROR: UNRECOGNIZED SELECTION STRING');
                          }

                          Entry entry = Entry(
                              name: name ?? '',
                              amount: amt,
                              //all tags stored in lowercase
                              tagString:
                                  tags != null ? tags.toLowerCase() : tags,
                              date: DateTime.now(),
                              type: type);
                          await db.addEntry(entry);

                          if (widget.backgroundStatus == 1) {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');

                            Navigator.pop(context);
                          } else if (widget.backgroundStatus == 0) {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');

                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return HomeScreen();
                            }));
                          }
                        } else {
                          hasError = true;
                          if (amtValidator != 0) {
                            setState(() {
                              col1 = Colors.red;
                            });
                          }
                          if (nameValidator != 0) {
                            if (selection == 'Expense' ||
                                selection == 'Deposit') {
                              setState(() {
                                col2 = Colors.red;
                              });
                            }
                          }
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        )));
  }
}
