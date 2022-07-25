import 'package:flutter/material.dart';
import 'package:test_tp21/conf/conf.dart';

import 'camera.dart';

class FaceCaptureInfo extends StatelessWidget {
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
                  flex: 4,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(Icons.account_box_outlined),
                  ),
                ),
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
                          'Face recognition',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                          ),
                          textScaleFactor: 2,
                        ),
                        Spacer(
                          flex: 3,
                        ),
                        Text(
                            'In order to identify you, as the last step we need to identify you with the help of facial recognition.',
                            textAlign: TextAlign.center),
                        Spacer(
                          flex: 2,
                        ),
                        Text(
                            'For the best results make sure that you have good lightning and align your face with the guidelines.',
                            textAlign: TextAlign.center),
                        Spacer(
                          flex: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraScreen()),
                    );
                  },
                  child: Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
