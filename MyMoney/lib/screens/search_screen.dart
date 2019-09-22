import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:my_money/engine/engine.dart';
import 'package:my_money/engine/entry.dart';
import 'package:my_money/screens/overview_screen.dart';
import 'package:my_money/screens/total_expense_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = '';
  String type = '';
  String tags = '';
  Color color1 = Colors.green[200];
  Color color2 = Colors.green[600];
  Color color3 = Colors.green[800];

  bool searchRendered = false;
  bool searchFruitful = false;

  List<Entry> searchList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.grey[600],
        appBar: AppBar(
          title: textConstruct(' Search', Colors.grey[200], true, 26),
          backgroundColor: Color.fromARGB(255, 55, 90, 120),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10, top: 20, left: 75),
                child: TextField(
                  onChanged: (text) {
                    name = text;
                  },
                  decoration: new InputDecoration.collapsed(
                    hintStyle: TextStyle(color: Colors.grey[300], fontSize: 18),
                    hintText: 'Name: ',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 10, top: 10, left: 75),
                child: TextField(
                  onChanged: (text) {
                    tags = text;
                  },
                  decoration: new InputDecoration.collapsed(
                    hintStyle: TextStyle(color: Colors.grey[300], fontSize: 18),
                    hintText: 'Tag: ',
                  ),
                ),
              ),
              Container(
                  child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //Withdrawal
                  RaisedButton(
                    color: color1,
                    child: textConstruct('Withdrawal', Colors.black, false, 15),
                    onPressed: () {
                      setState(() {
                        if (type == 'Withdrawal') {
                          type = '';
                          color1 = Colors.green[200];
                          color2 = Colors.green[600];
                          color3 = Colors.green[800];
                        } else {
                          color2 = Colors.grey;
                          color3 = Colors.grey;
                          color1 = Colors.green[200];
                          type = 'Withdrawal';
                        }
                      });
                    },
                  ),
                  //Expense
                  RaisedButton(
                    color: color2,
                    child: textConstruct('Expense', Colors.black, false, 15),
                    onPressed: () {
                      setState(() {
                        if (type == 'Expense') {
                          type = '';
                          color1 = Colors.green[200];
                          color2 = Colors.green[600];
                          color3 = Colors.green[800];
                        } else {
                          color1 = Colors.grey;
                          color3 = Colors.grey;
                          color2 = Colors.green[600];
                          type = 'Expense';
                        }
                      });
                    },
                  ),
                  //deposit
                  RaisedButton(
                    color: color3,
                    child: textConstruct('Deposit', Colors.black, false, 15),
                    onPressed: () {
                      setState(() {
                        if (type == 'Deposit') {
                          type = '';
                          color1 = Colors.green[200];
                          color2 = Colors.green[600];
                          color3 = Colors.green[800];
                        } else {
                          color1 = Colors.grey;
                          color2 = Colors.grey;
                          color3 = Colors.green[800];
                          type = 'Deposit';
                        }
                      });
                    },
                  ),
                ],
              )),
              Visibility(
                visible: searchRendered,
                replacement: Container(
                  padding: EdgeInsets.only(
                    bottom: 10,
                    top: 30,
                  ),
                  height: 200,
                  width: 200,
                  child: textConstruct(
                      'Search With\nAbove Criteria', Colors.grey, true, 20),
                ),
                child: (searchFruitful != true)
                    ? Container(
                        padding: EdgeInsets.only(
                          bottom: 10,
                          top: 30,
                        ),
                        height: 200,
                        width: 200,
                        child: textConstruct('No Results\nPlease Try Again',
                            Colors.grey, true, 20),
                      )
                    : Container(
                        height: 300,
                        width: 350,
                        child: ListView.builder(
                          itemCount: searchList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Entry entry = searchList[index];

                            return FlatButton(
                              child: expenseButton(entry),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Container(
                                          height:
                                              (entry.tags != null) ? 430 : 300,
                                          width: 275,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(7.0),
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Expanded(
                                                          child: Container(
                                                        child: textConstruct(
                                                            '${entry.name}',
                                                            Colors
                                                                .blueGrey[800],
                                                            true,
                                                            18),
                                                      )),
                                                      Container(
                                                          height: 30,
                                                          width: 30,
                                                          child:
                                                              FloatingActionButton(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent,
                                                                  child:
                                                                      Text('x'),
                                                                  onPressed:
                                                                      () async {
                                                                    //delete entry;

                                                                    setState(
                                                                        () {
                                                                      if (entry.type ==
                                                                              'Card Expense' ||
                                                                          entry.type ==
                                                                              'Withdrawal') {
                                                                        cardBalance =
                                                                            cardBalance +
                                                                                entry.amount;
                                                                        setDouble(
                                                                            'cardBalance',
                                                                            cardBalance);
                                                                      } else if (entry
                                                                              .type ==
                                                                          'Cash Expense') {
                                                                        cashBalance =
                                                                            cashBalance +
                                                                                entry.amount;
                                                                        setDouble(
                                                                            'cashBalance',
                                                                            cashBalance);
                                                                      } else if (entry
                                                                              .type ==
                                                                          'Cash Deposit') {
                                                                        cashBalance =
                                                                            cashBalance -
                                                                                entry.amount;
                                                                        setDouble(
                                                                            'cashBalance',
                                                                            cashBalance);
                                                                      } else if (entry
                                                                              .type ==
                                                                          'Card Deposit') {
                                                                        cardBalance =
                                                                            cardBalance -
                                                                                entry.amount;
                                                                        setDouble(
                                                                            'cardBalance',
                                                                            cardBalance);
                                                                      }

                                                                      if (entry
                                                                              .type
                                                                              .contains('Expense') ==
                                                                          true) {
                                                                        if (findPriorSunday(entry.date) !=
                                                                            findPriorSunday(DateTime.now())) {
                                                                          //actions -> add to budget if expense
                                                                          wkSpent =
                                                                              wkSpent - entry.amount;
                                                                          budget =
                                                                              budget + entry.amount;
                                                                          setDouble(
                                                                              'budget',
                                                                              budget);
                                                                        }
                                                                      }
                                                                      wkSearch.remove(
                                                                          entry);

                                                                      entryList
                                                                          .remove(
                                                                              entry);
                                                                    });
                                                                    await db.removeEntry(
                                                                        entry
                                                                            .id);
                                                                    setState(
                                                                        () {
                                                                      db.getLastWeek();
                                                                    });

                                                                    Navigator.pop(
                                                                        context);
                                                                  })),
                                                    ]),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Divider(
                                                  color: Colors.black,
                                                  indent: 5,
                                                  endIndent: 5,
                                                ),
                                              ),

                                              //remaining budget
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                child: textConstruct(
                                                    '\$${entry.amount.toStringAsFixed(2)}',
                                                    colorAdjust(entry.amount),
                                                    true,
                                                    30),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                child: textConstruct(
                                                    '${entry.type}',
                                                    Colors.green[900],
                                                    true,
                                                    22),
                                              ),

                                              Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: 20,
                                                  ),
                                                  child: Column(children: [
                                                    textConstruct(
                                                        '${DateFormat.yMMMd().format(entry.date)}',
                                                        Colors.blueGrey,
                                                        true,
                                                        20),
                                                    textConstruct(
                                                        '${DateFormat.EEEE().format(entry.date)}',
                                                        Colors.blueGrey[800],
                                                        true,
                                                        18),
                                                  ])),

                                              Visibility(
                                                  child: Column(
                                                    children: <Widget>[
                                                      textConstruct(
                                                          'tags\n',
                                                          Colors.grey[700],
                                                          false,
                                                          15),
                                                      Container(
                                                        alignment:
                                                            Alignment(0.0, 0.0),
                                                        height: 100,
                                                        child: ListView.builder(
                                                            itemCount:
                                                                (entry.tags !=
                                                                        null)
                                                                    ? entry.tags
                                                                        .length
                                                                    : 0,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return textConstruct(
                                                                  '${entry.tags[index]}',
                                                                  Colors.black,
                                                                  false,
                                                                  18);
                                                            }),
                                                      ),
                                                    ],
                                                  ),
                                                  visible: entry.tags != null),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: RaisedButton(
                                                    child: Text("ok"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                            );
                          },
                        )),
              ),
              Container(
                width: 150,
                height: 50,
                child: RaisedButton(
                  color: Colors.blueGrey,
                  child: Row(children: [
                    Icon(
                      Icons.search,
                      size: 27,
                      color: Colors.white,
                    ),
                    textConstruct('Search!', Colors.white, true, 20)
                  ]),
                  onPressed: () async {
                    if (name == null || name.trim() == '') {
                      name = null;
                    }
                    if (type == null || type.trim() == '') {
                      type = null;
                    }
                    if (tags == null || tags.trim() == '') {
                      tags = null;
                    }
                    //launch the search
                    await db.search(name, tags, type).then((list) {
                      list = list.toSet().toList();
                      setState(() {
                        searchList = list;
                        searchRendered = true;
                        if (searchList == null || searchList.length == 0) {
                          searchFruitful = false;
                        } else {
                          searchFruitful = true;
                        }
                      });
                      return list;
                    });
                  },
                ),
              )
            ],
          ),
        ));
  }
}
