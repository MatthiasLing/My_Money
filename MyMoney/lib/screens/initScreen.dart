import 'package:flutter/material.dart';

import 'package:my_money/engine/engine.dart';
import 'package:my_money/main.dart';
import 'package:my_money/screens/home_screen.dart';

String tempUsername;
String tempPassword;
bool usernameOk = false;
bool passwordOk = false;

class InitScreen extends StatefulWidget {
  @override
  _InitScreenState createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  bool hasError = false;
  //goes to the overview screen
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Container(
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                },
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textConstruct("Create New Profile", Colors.white, true, 30),
                    Container(
                        padding: EdgeInsets.only(
                          top: 20,
                        ),
                        width: 200,
                        child: TextField(
                          decoration: InputDecoration(hintText: 'username'),
                          onChanged: (text) {
                            setState(() {
                              tempUsername = text;
                              if (text != null) {
                                usernameOk = true;
                              } else {
                                usernameOk = false;
                              }
                            });
                          },
                        )),
                    Container(
                        padding: EdgeInsets.only(
                          top: 40,
                        ),
                        width: 200,
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: 'new password'),
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            tempPassword = text;
                          },
                        )),
                    Container(
                        width: 200,
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(hintText: 'confirm'),
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            setState(() {
                              if (text == tempPassword) {
                                passwordOk = true;
                              } else {
                                passwordOk = false;
                              }
                            });
                          },
                        )),
                    Visibility(
                        visible: (passwordOk == true && usernameOk == true),
                        child: Container(
                            child: FlatButton(
                          color: Colors.orangeAccent,
                          child:
                              textConstruct("Submit", Colors.white, true, 25),
                          onPressed: () {
                            setUser("password", tempPassword);
                            setUser("username", tempUsername);
                            password = tempPassword;
                            username = tempUsername;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return HomeScreen();
                              }),
                            );
                          },
                        )))
                  ],
                )))));
  }
}
