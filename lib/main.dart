import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_tp21/company.dart';
import 'package:test_tp21/conf/conf.dart';
import 'package:test_tp21/token_invalid.dart';
import 'package:test_tp21/utils/services/backend_connection_service.dart';
import 'package:uni_links/uni_links.dart';
import 'gdpr.dart';
import 'model/IdentificationMetaData.dart';

bool tokenValidity = false;

Future<void> initUniLinks() async {
  try {
    final initialUri = await getInitialUri();
    if (initialUri == null) {
      return null;
    }

    var identity = IdentificationMetaData();
    var personUuid = initialUri.queryParameters['token'];
    if (personUuid != null) {
      identity.personUuid = personUuid;
      tokenValidity = await checkTokenValidity(identity.personUuid);
    }
  } on FormatException {
    return null;
  }
}

Future<void> main() async {
  runApp(MyApp());
  await initUniLinks();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: MyHomePage(title: title),
      theme: ThemeData(
          primaryColor: Colors.black,
          appBarTheme: AppBarTheme(
              systemOverlayStyle: (SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  statusBarBrightness: Brightness.light
              )),
              backgroundColor: Colors.black,
              centerTitle: true),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all<TextStyle>
                    (TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<OutlinedBorder>
                    (RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  padding: MaterialStateProperty.all<EdgeInsets>
                    (EdgeInsets.symmetric(horizontal: 22, vertical: 12))
              )),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.black,
            textTheme: ButtonTextTheme.primary,
          )),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _valueGeneralTermsAndConditionsAndGdpr = false;

  void _agreedToGeneralTermsAndConditionsAndGdpr(bool? newValue) => setState(() {
    _valueGeneralTermsAndConditionsAndGdpr = newValue!;
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.3), BlendMode.dstATop),
                    child : Image.asset('assets/jezko.png',
                      fit: BoxFit.cover, alignment: Alignment.center,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('As the first step, '
                      'it is necessary to take a photo of your '
                      'identity card from both sides and accept GDPR.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 23.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                    child: Row(
                      children: [
                        Container(child: Theme(
                          child: Checkbox(
                            value: _valueGeneralTermsAndConditionsAndGdpr,
                            onChanged: _agreedToGeneralTermsAndConditionsAndGdpr,
                          ),
                          data: ThemeData(
                            primarySwatch: Colors.blue,
                            unselectedWidgetColor: Colors.red,
                          ),
                        )),
                        Container(child: Text("I agree to ")),
                        Expanded(child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return GdprDialog(mdFileName: 'gdpr.md');
                              },
                            );
                          },
                          child: Text(
                            "General Terms & Conditions and GDPR.",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),),
                      ],
                    )
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style: Theme.of(context).elevatedButtonTheme.style,
                    onPressed: () async {
                      var identity = IdentificationMetaData();
                      if(_valueGeneralTermsAndConditionsAndGdpr) {
                        if (identity.personUuid != null) {
                          if (tokenValidity) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Company()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TokenInvalid()),
                            );
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text("You need to open the app through link provided in e-mail requesting verification."),
                              )
                          );
                        }
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text("You need to agree to GDPR"),
                            )
                        );
                      }
                    },
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
