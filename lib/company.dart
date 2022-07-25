import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:test_tp21/conf/conf.dart';
import 'package:test_tp21/model/IdentificationMetaData.dart';
import 'blink.dart';

class Company extends StatelessWidget {
  Widget createCompanyList() {
    var identity = IdentificationMetaData();
    var jsonData = identity.personBackendData;
    List<Widget> companyWidgetList = [];
    companyWidgetList.add(_buildCompanyWidget(jsonData));

    return Column(
      children: companyWidgetList,
    );
  }

  Widget _buildCompanyWidget(company) {
    return Row(
      children: [Text(company[0]['name']), Spacer(), Text(company[0]['id_number'])],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context),
      home: LoaderOverlay(
        child: Scaffold(
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
              child: ListView(
                children: [
                  FittedBox(
                    fit: BoxFit.fill,
                    child: Icon(Icons.account_balance_outlined),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 50),
                    child: Column(children: [
                      Text(
                        'Companies in which you are authenticated:',
                        textAlign: TextAlign.center,
                        style: TextStyle(),
                        textScaleFactor: 2,
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      createCompanyList(),
                    ]),
                  ),
                  ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BlinkIdPage()),
                      );
                    },
                    child: Text('Continue'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
