import 'package:flutter/material.dart';
import 'package:test_tp21/conf/conf.dart';

class TokenInvalid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context),
      home: Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            title,
            textScaleFactor: 2,
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          )),
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: Column(
                      children: [
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          'Your token is invalid or was already used.',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          textScaleFactor: 2,
                        ),
                        Spacer(
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
