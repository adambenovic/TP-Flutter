import 'package:flutter/material.dart';
import 'package:test_tp21/model/IdentificationMetaData.dart';
import 'package:test_tp21/photo_source_select.dart';

import 'model/enums/DocType.dart';

class DocTypeSelectPage extends StatefulWidget {
  @override
  _DocTypeSelectPageState createState() => _DocTypeSelectPageState();
}

class _DocTypeSelectPageState extends State<DocTypeSelectPage> {
  static const optionsDocs = [
    [Icons.add, "ID", true, DocType.id],
    [Icons.add, "Passport", false, DocType.passport],
  ];

  List<Widget> getListOfDocButtons() {
    var buttons = <Widget>[];
    optionsDocs.forEach((element) {
      buttons.add(generateButtonFromItem(element));
    });
    return buttons;
  }

  Widget generateButtonFromItem(List item) {
    return OutlinedButton(
      onPressed: item[2]
          ? () {
              IdentificationMetaData().expectedDocType = item[3];
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PhotoSourceSelectPage()),
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
                            "Choose the type of your identification document:",
                            textScaleFactor: 2,
                            textAlign: TextAlign.center,
                          )
                        ] +
                        getListOfDocButtons()),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
