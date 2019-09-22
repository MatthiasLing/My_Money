import 'package:flutter/material.dart';
import 'package:my_money/engine/engine.dart';
import 'overview_screen.dart';

class BudgetDialog extends StatefulWidget {
  double hrs;
  double rate;
  double pct;

  BudgetDialog({
    this.hrs,
    this.rate,
    this.pct,
  });
  @override
  _BudgetDialogState createState() => new _BudgetDialogState();
}

class _BudgetDialogState extends State<BudgetDialog> {
  double rateCheck = -1;
  double hrsCheck = -1;
  double pctCheck = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          color: Colors.blueGrey[300],
          height: 400,
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5, top: 12, left: 10),
                  child:
                      textConstruct('Current Budget', Colors.white, true, 23),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.black,
                    indent: 5,
                    endIndent: 5,
                  ),
                ),

                //Rate
                Container(
                  padding: EdgeInsets.only(bottom: 10, top: 10, left: 10),
                  child: TextField(
                    onChanged: (String text) {
                      if (!regex.hasMatch(text)) {
                        setState(() {
                          rateCheck = -1;
                        });
                      } else {
                        setState(() {
                          rateCheck = double.parse(text);
                        });
                      }
                    },
                    decoration: new InputDecoration.collapsed(
                      hintText:
                          'Rate per hour: \$${widget.rate.toStringAsFixed(2)}',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ),

                //hours
                Container(
                  padding: EdgeInsets.only(bottom: 10, top: 10, left: 10),
                  child: TextField(
                    onChanged: (String text) {
                      if (!regex.hasMatch(text)) {
                        setState(() {
                          hrsCheck = -1;
                        });
                      } else {
                        setState(() {
                          hrsCheck = double.parse(text);
                        });
                      }
                    },
                    decoration: new InputDecoration.collapsed(
                      hintText:
                          'Hours per week: ${widget.hrs.toStringAsFixed(2)}',
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ),

                //percentage
                Container(
                  padding: EdgeInsets.only(bottom: 10, top: 10, left: 10),
                  child: TextField(
                    onChanged: (String text) {
                      if (!regex.hasMatch(text)) {
                        setState(() {
                          pctCheck = -1;
                        });
                      } else {
                        setState(() {
                          pctCheck = double.parse(text);
                        });
                      }
                    },
                    decoration: new InputDecoration.collapsed(
                      hintText:
                          'Percentage to spend: ${widget.pct.toStringAsFixed(0)}%',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),

                Visibility(
                  replacement: Column(
                    children: <Widget>[
                      textConstruct(
                          '\n\$${(rate * hrs * pct / 100).toStringAsFixed(2)}',
                          remainderAdjust(
                              rateCheck * hrsCheck * pctCheck / 100),
                          true,
                          20),
                      textConstruct(
                          'Current Budget Structure', Colors.black, false, 15),
                      textConstruct('\n\$${budget.toStringAsFixed(2)}',
                          remainderAdjust(budget), true, 20),
                      textConstruct('Remaining', Colors.black, false, 15),
                    ],
                  ),
                  visible: rateCheck >= 0 && hrsCheck >= 0 && pctCheck >= 0,
                  child: Container(
                    alignment: Alignment(0.0, 0.0),
                    height: 100,
                    width: 150,
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Column(
                      children: <Widget>[
                        textConstruct(
                            '\n\$${(rateCheck * hrsCheck * pctCheck / 100).toStringAsFixed(2)}',
                            Colors.green[800],
                            true,
                            20),
                        textConstruct(
                            'Projected Budget', Colors.black, false, 15),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                      child: Text("submit"),
                      onPressed: () {
                        if (rateCheck != -1 && hrsCheck != -1 && pct != -1) {
                          budget = (hrsCheck * rateCheck * pctCheck / 100);
                          setDouble('budget', budget);
                          setDouble('hrs', hrsCheck);
                          setDouble('rate', rateCheck);
                          setDouble('pct', pctCheck);
                        }
                        Navigator.pop(context);
                      }),
                )
              ],
            ),
          )),
    );
  }
}
