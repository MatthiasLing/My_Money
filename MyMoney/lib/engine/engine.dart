import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_money/screens/overview_screen.dart';
import 'package:my_money/engine/entry.dart';

Pattern pattern =
    r'^\$?([0-9]{1,3},([0-9]{3},)*[0-9]{3}|[0-9]+)(.[0-9][0-9])?$';
RegExp regex = new RegExp(pattern);

Text textConstruct(String text, Color color, bool isBold, double size) {
  return Text(
    text,
    style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: (isBold == true) ? FontWeight.bold : FontWeight.normal),
    textAlign: TextAlign.center,
  );
}

DateTime findPriorSunday(DateTime date) {
  DateTime sunday;
  if (date.weekday == 7) {
    sunday = date;
  } else {
    //subtract number of weekdays
    sunday = date.subtract(Duration(days: date.weekday));
  }
  return sunday;
}

String dateAdjust(DateTime date) {
  DateTime boundary1;
  DateTime boundary2;
  DateTime temp;
  //find the most recent sunday
  temp = findPriorSunday(DateTime.now());
  boundary1 = DateTime(temp.year, temp.month, temp.day);

  //find the sunday prior to the date
  temp = findPriorSunday(date);
  boundary2 = DateTime(temp.year, temp.month, temp.day);
  //difference between the two sundays / 7 is x weeks ago

  int duration = (boundary1.difference(boundary2).inDays / 7).toInt();
  duration = duration.floor();
  if (duration == 0) {
    //calculate number of days
    temp = DateTime.now();
    boundary1 = DateTime(temp.year, temp.month, temp.day);
    boundary2 = DateTime(date.year, date.month, date.day);
    duration = boundary1.difference(boundary2).inDays;
    if (duration == 0) {
      return 'today';
    } else if (duration == 1) {
      return 'yesterday';
    } else {
      return '${duration.toStringAsFixed(0)} days ago';
    }
  } else if (duration == 1) {
    return 'last week';
  } else {
    return '${duration.toStringAsFixed(0)} weeks ago';
  }
}

Color colorAdjust(double amt) {
  Color ret;
  if (amt <= 5) {
    ret = Colors.yellow[400];
  } else if (amt <= 10) {
    ret = Colors.yellow[700];
  } else if (amt <= 20) {
    ret = Colors.yellow[800];
  } else if (amt <= 50) {
    ret = Colors.yellow[900];
  } else {
    ret = Color.fromARGB(255, 241, 29, 40);
  }
  return ret;
}

Color remainderAdjust(double amt) {
  Color ret;
  if (amt <= 10) {
    ret = Color.fromARGB(255, 241, 29, 40);
  } else if (amt <= 20) {
    ret = Colors.yellow[800];
  } else if (amt <= 50) {
    ret = Colors.yellow[700];
  } else {
    ret = Colors.yellow[400];
  }
  return ret;
}

Widget expenseButton(Entry entry) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      Expanded(
        child: Container(
          alignment: Alignment.centerLeft,
          child: textConstruct(
              '\$' + entry.amount.toStringAsFixed(2),
              entry.type.contains('Deposit')
                  ? Colors.green
                  : colorAdjust(entry.amount),
              true,
              16),
        ),
      ),
      Expanded(
          child: Container(
              alignment: Alignment.center,
              child: textConstruct(entry.name, Colors.white70, true, 15))),
      Expanded(
          child: Container(
              alignment: Alignment.centerRight,
              child: textConstruct(
                  dateAdjust(entry.date), Colors.greenAccent, false, 14)))
    ],
  );
}

//Shared prefs info
/*
  keys: 
    budget
    cashBalance
    cardBalance
    hrs
    rate
    pct
 */
Future<void> updateBudgetPrefs() async {
  budget = await getDouble('budget');
  hrs = await getDouble('hrs');
  rate = await getDouble('rate');
  pct = await getDouble('pct');
}

Future<String> getUser(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String ret = prefs.getString(key);
  if (ret == null) {
    return null;
  }
  return ret;
}

Future<bool> setUser(String key, String str) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, str);
  return prefs.commit();
}

Future<double> getDouble(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double ret = prefs.getDouble(key);
  if (ret == null) {
    return null;
  }
  return ret;
}

Future<bool> setDouble(String key, double amt) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(key, amt);
  return prefs.commit();
}

bool contains(List<Entry> list, Entry entry) {
  for (int i = 0; i < list.length; i++) {
    if (list[i].id == entry.id) {
      return true;
    }
  }
  return false;
}
