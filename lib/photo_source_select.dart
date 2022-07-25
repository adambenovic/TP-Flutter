import 'package:flutter/material.dart';

import 'blink.dart';

class PhotoSourceSelectPage extends StatefulWidget {
  @override
  _PhotoSourceSelectPageState createState() => _PhotoSourceSelectPageState();
}

class _PhotoSourceSelectPageState extends State<PhotoSourceSelectPage> {
  static const options = [
    [Icons.camera_alt_outlined, "Take a Photo now", true, BlinkIdPage()],
    [Icons.archive_outlined, "Take from Gallery", false, null],
  ];

  List<Widget> getListOfSourceButtons() {
    var buttons = <Widget>[];
    options.forEach((element) {
      buttons.add(generateButtonFromItem(element));
    });
    return buttons;
  }

  Widget generateButtonFromItem(List item) {
    return OutlinedButton(
      onPressed: item[2]
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item[3]),
              );
            }
          : null,
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Expanded(
              flex: 2,
              child: Icon(item[0]),
            ),
            Expanded(
              flex: 3,
              child: Text(item[1]),
            ),
            Expanded(
              flex: 3,
              child: !item[2] ? Text("Coming Soon!") : Text(""),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Theme.of(context),
        home: Scaffold(
          appBar: AppBar(
            title: Text("KLYCK"),
          ),
          body: Column(
            children: [
              Expanded(child: Container(), flex: 6),
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: (<Widget>[
                          Text(
                            "Choose your ID:",
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                          )
                        ] +
                        getListOfSourceButtons()),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
