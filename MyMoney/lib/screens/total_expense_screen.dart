import 'package:flutter/material.dart';
import 'package:my_money/engine/engine.dart';
import 'package:intl/intl.dart';
import 'package:my_money/database/database_helper.dart';
import 'package:my_money/engine/entry.dart';
import 'package:my_money/screens/overview_screen.dart';
import 'package:my_money/screens/search_screen.dart';

final db = EntryDataBase();

final _formKey = GlobalKey<FormState>();

List<Entry> wkSearch = [];
List<Entry> entryList = [];

class TotalExpenseScreen extends StatefulWidget {
  @override
  _TotalExpenseScreenState createState() => _TotalExpenseScreenState();
}

class _TotalExpenseScreenState extends State<TotalExpenseScreen> {
  @override
  void initState() {
    super.initState();
    setupList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(children: [
        Center(
          child: Container(
              color: Colors.blueGrey[700],
              child: Padding(
                padding: EdgeInsets.only(
                  left: 5,
                  top: 5,
                  right: 5,
                  bottom: 10,
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          top: 20,
                          right: 5,
                          bottom: 5,
                        ),
                        child: textConstruct('Recent Expenditures',
                            Colors.greenAccent, true, 20)),
                    Divider(
                      color: Colors.black,
                      indent: 5,
                      endIndent: 5,
                    ),
                    Container(
                        height: 550,
                        child: ListView.builder(
                          itemCount: entryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            Entry entry =
                                entryList[entryList.length - 1 - index];

                            return FlatButton(
                              child: expenseButton(entry),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Container(
                                          height:
                                              (entry.tags != null) ? 430 : 320,
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
                                                              Colors.blueGrey[
                                                                  800],
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
                                                                    child: Text(
                                                                        'x'),
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
                                                                              cardBalance + entry.amount;
                                                                          setDouble(
                                                                              'cardBalance',
                                                                              cardBalance);
                                                                        } else if (entry.type ==
                                                                            'Cash Expense') {
                                                                          cashBalance =
                                                                              cashBalance + entry.amount;
                                                                          setDouble(
                                                                              'cashBalance',
                                                                              cashBalance);
                                                                        } else if (entry.type ==
                                                                            'Cash Deposit') {
                                                                          cashBalance =
                                                                              cashBalance - entry.amount;
                                                                          setDouble(
                                                                              'cashBalance',
                                                                              cashBalance);
                                                                        } else if (entry.type ==
                                                                            'Card Deposit') {
                                                                          cardBalance =
                                                                              cardBalance - entry.amount;
                                                                          setDouble(
                                                                              'cardBalance',
                                                                              cardBalance);
                                                                        }

                                                                        if (entry.type.contains('Expense') ==
                                                                            true) {
                                                                          if (findPriorSunday(entry.date) !=
                                                                              findPriorSunday(DateTime.now())) {
                                                                            wkSpent =
                                                                                wkSpent - entry.amount;
                                                                            budget =
                                                                                budget + entry.amount;
                                                                            setDouble('budget',
                                                                                budget);
                                                                          }
                                                                        }
                                                                        wkSearch
                                                                            .remove(entry);
                                                                        entryList
                                                                            .remove(entry);
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
                                                      ])),
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
                                                        height: 80,
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
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                          ),
                        )),
                  ],
                ),
              )
              //Button bar? [button: Amt spent in last week - onclick load those things,
              //             button: amount left in weekly budget - onclick load budget info
              //             button: search]
              ),
        ),
        Positioned(
          bottom: -10,
          child: ButtonBar(alignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
                height: 100,
                width: 130,
                child: RaisedButton(
                  color: Colors.grey[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                              bottom: 5,
                            ),
                            child: textConstruct(
                                '\$${wkSpent.toStringAsFixed(2)}',
                                Colors.white,
                                true,
                                20)),
                        //main button
                        textConstruct('spent this wk', Colors.black, false, 14),
                      ]),
                  onPressed: () {
                    setState(() {
                      // db.getLastWeek();
                    });
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Form(
                              child: Container(
                                color: Colors.blueGrey,
                                height: 400,
                                width: 300,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: textConstruct('This Week',
                                          Colors.grey[100], true, 25),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Divider(
                                        color: Colors.black,
                                        indent: 5,
                                        endIndent: 5,
                                      ),
                                    ),
                                    Container(
                                        height: 250,
                                        width: 300,
                                        child: ListView.builder(
                                          itemCount: wkSearch.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Entry entry = wkSearch[
                                                wkSearch.length - 1 - index];

                                            return FlatButton(
                                              child: expenseButton(entry),
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        content: Container(
                                                          height: (entry.tags !=
                                                                  null)
                                                              ? 430
                                                              : 300,
                                                          width: 275,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: textConstruct(
                                                                    '${entry.name}',
                                                                    Colors.blueGrey[
                                                                        800],
                                                                    true,
                                                                    18),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Divider(
                                                                  color: Colors
                                                                      .black,
                                                                  indent: 5,
                                                                  endIndent: 5,
                                                                ),
                                                              ),

                                                              //remaining budget
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom: 10,
                                                                ),
                                                                child: textConstruct(
                                                                    '\$${entry.amount.toStringAsFixed(2)}',
                                                                    colorAdjust(
                                                                        entry
                                                                            .amount),
                                                                    true,
                                                                    30),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  bottom: 10,
                                                                ),
                                                                child: textConstruct(
                                                                    '${entry.type}',
                                                                    Colors.green[
                                                                        900],
                                                                    true,
                                                                    22),
                                                              ),

                                                              Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .only(
                                                                    bottom: 20,
                                                                  ),
                                                                  child: Column(
                                                                      children: [
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
                                                                    children: <
                                                                        Widget>[
                                                                      textConstruct(
                                                                          'tags\n',
                                                                          Colors
                                                                              .grey[700],
                                                                          false,
                                                                          15),
                                                                      Container(
                                                                        alignment: Alignment(
                                                                            0.0,
                                                                            0.0),
                                                                        height:
                                                                            100,
                                                                        child: ListView.builder(
                                                                            itemCount: (entry.tags != null) ? entry.tags.length : 0,
                                                                            itemBuilder: (BuildContext context, int index) {
                                                                              return textConstruct('${entry.tags[index]}', Colors.black, false, 18);
                                                                            }),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  visible: entry
                                                                          .tags !=
                                                                      null),

                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    RaisedButton(
                                                                        child: Text(
                                                                            "ok"),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
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
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                        )),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                          child: Text("ok"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                )),
            Container(
              height: 100,
              width: 120,
              child: RaisedButton(
                color: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                            bottom: 5,
                          ),
                          child: textConstruct('\$${budget.toStringAsFixed(2)}',
                              remainderAdjust(budget), true, 20)),
                      Text('left in budget'),
                    ]),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Form(
                            key: _formKey,
                            child: Container(
                              height: 300,
                              width: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: textConstruct(
                                        'My Budget', Colors.black, true, 20),
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
                                  Container(
                                    // padding: EdgeInsets.only(
                                    //   bottom: 10,
                                    // ),
                                    child: Row(children: [
                                      textConstruct(
                                          '\$${budget.toStringAsFixed(2)}',
                                          remainderAdjust(budget),
                                          true,
                                          25),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                        ),
                                        child: textConstruct('Remaining',
                                            Colors.blueGrey, false, 20),
                                      )
                                    ]),
                                  ),

                                  //initial budget, #hours worked @ rate
                                  Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: Column(children: [
                                        Row(
                                          children: [
                                            textConstruct(
                                                '\$${(hrs * rate * pct / 100).toStringAsFixed(2)}',
                                                Colors.black,
                                                true,
                                                25),
                                            Container(
                                                padding: EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    textConstruct(
                                                        'Initital',
                                                        Colors.blueGrey,
                                                        false,
                                                        20),
                                                    textConstruct(
                                                        '${hrs.toStringAsFixed(2)} hrs worked',
                                                        Colors.grey,
                                                        false,
                                                        15),
                                                    textConstruct(
                                                        '\$${rate.toStringAsFixed(2)}/hr',
                                                        Colors.grey,
                                                        false,
                                                        15),
                                                  ],
                                                ))
                                          ],
                                        ),
                                      ])),

                                  //spent this week
                                  Padding(
                                    padding: EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: Row(children: [
                                      textConstruct(
                                          '\$${wkSpent.toStringAsFixed(2)}',
                                          colorAdjust(wkSpent),
                                          true,
                                          25),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                        ),
                                        child: textConstruct('Spent',
                                            Colors.blueGrey, false, 20),
                                      )
                                    ]),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                        child: Text("ok"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
              ),
            ),
            Container(
              height: 100,
              width: 100,
              child: FloatingActionButton(
                child: Icon(Icons.search, size: 30),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return SearchScreen();
                    }),
                  );
                },
              ),
            )
          ]),
        )
      ]),
    );
  }

  void setupList() async {
    var _table = await db.fetchAll();
    setState(() {
      entryList = _table;
    });
  }
}
