import 'package:flutter/material.dart';
import 'package:my_money/screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: HomeScreen());
  }
}
