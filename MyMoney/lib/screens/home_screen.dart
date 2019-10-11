import 'package:flutter/material.dart';
import 'package:pin_code_view/pin_code_view.dart';
import 'overview_screen.dart';
import 'new_expense_screen.dart';
import 'package:my_money/engine/engine.dart';
import 'package:my_money/main.dart';

Size size;

void initBudgetBalances() async {
  getDouble('budget').then((double value) {
    if (value == null) {
      budget = 0;
      setDouble('budget', 0);
    } else {
      budget = value;
    }
    return budget;
  });
  cashBalance = await getDouble('cashBalance').then((double onValue) async {
    if (onValue == null) {
      cashBalance = 0;
      await setDouble('cashBalance', 0);
    } else {
      cashBalance = onValue;
    }
    return cashBalance;
  });
  cardBalance = await getDouble('cardBalance').then((double onValue) async {
    if (onValue == null) {
      cardBalance = 0;
      await setDouble('cardBalance', 0);
    } else {
      cardBalance = onValue;
    }
    return cardBalance;
  });
  hrs = await getDouble('hrs').then((double onValue) async {
    if (onValue == null) {
      hrs = 0;
      await setDouble('hrs', 0);
    } else {
      hrs = onValue;
    }
    return hrs;
  });
  rate = await getDouble('rate').then((double onValue) async {
    if (onValue == null) {
      rate = 0;
      await setDouble('rate', 0);
    } else {
      rate = onValue;
    }
    return rate;
  });
  pct = await getDouble('pct').then((double onValue) async {
    if (onValue == null) {
      pct = 0;
      await setDouble('pct', 0);
    } else {
      pct = onValue;
    }
    return pct;
  });
}

class HomeScreen extends StatefulWidget {
  final Function unlocked;

  HomeScreen({this.unlocked});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasError = false;
  //goes to the overview screen
  @override
  void initState() {
    initBudgetBalances();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return new Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        children: [
          Stack(
            children: <Widget>[
              Container(
                child: PinCode(
                  obscurePin: true,
                  title: Text(
                    "Welcome " + username,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold),
                  ),
                  subTitle: Text(
                    "Scroll up to record new expense",
                    style: TextStyle(color: Colors.greenAccent, fontSize: 15),
                  ),
                  codeLength: password.length,
                  correctPin: password,
                  onCodeSuccess: (code) {
                    this.hasError = false;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return Overview();
                      }),
                    );
                  },
                  onCodeFail: (code) {
                    setState(() {
                      hasError = true;
                    });
                  },
                ),
              ),
              Visibility(
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    textConstruct('Wrong Pin', Colors.red[400], true, 30),
                    textConstruct(
                        'please try again', Colors.red[200], true, 20),
                    textConstruct('\n', Colors.red, true, 20)
                  ],
                )),
                visible: hasError == true,
              ),
            ],
          ),
          ExpenseScreen(
            backgroundStatus: 0,
          ),
        ],
      ),
    );
  }
}
