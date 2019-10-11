import 'package:flutter/material.dart';
import 'package:my_money/engine/engine.dart';
import 'package:my_money/screens/home_screen.dart';
import 'package:my_money/screens/initScreen.dart';

String password;
String username;

void main() async {
  password = await getUser('password').then((String pass) async {
    password = pass;
    return password;
  });
  username = await getUser('username').then((String user) async {
    username = user;
    return username;
  });

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //goes to the overview screen
  @override
  void initState() {
    initBudgetBalances();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: (username == null) ? InitScreen() : HomeScreen());
  }
}
