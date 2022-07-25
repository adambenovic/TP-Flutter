import "dart:async";
import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:flutter/material.dart';
import 'package:test_tp21/conf/conf.dart';
import 'package:test_tp21/form/idCardForm.dart';
import 'package:test_tp21/model/IdentificationMetaData.dart';
import 'package:test_tp21/utils/services/secrets_manager_service.dart';

class BlinkIdPage extends StatefulWidget {

  const BlinkIdPage({Key? key}) : super(key: key);
  @override
  _BlinkIdState createState() => _BlinkIdState();
}

class _BlinkIdState extends State<BlinkIdPage> {
  late BlinkIdCombinedRecognizerResult _result;
  String _fullDocumentFrontImageBase64 = "";
  String _fullDocumentBackImageBase64 = "";
  String _faceImageBase64 = "";
  var results;

  Future<void> scan() async {
    if (results != null && results.length > 0) {
      return;
    }

    String license;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      license = await getBlinkIDKey();
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      license = await getBlinkIDKey();
    } else {
      license = "";
    }

    var idRecognizer = BlinkIdCombinedRecognizer();
    idRecognizer.returnFullDocumentImage = true;
    idRecognizer.returnFaceImage = true;

    BlinkIdOverlaySettings settings = BlinkIdOverlaySettings();
    settings.language = 'en';

    results = await MicroblinkScanner.scanWithCamera(
        RecognizerCollection([idRecognizer]), settings, license);

    if (!mounted) return;

    if (results.length == 0) Navigator.pop(context);
    for (var result in results) {
      if (result is BlinkIdCombinedRecognizerResult) {
        setState(() {
          _result = result;
          _fullDocumentFrontImageBase64 = result.fullDocumentFrontImage ?? "";
          _fullDocumentBackImageBase64 = result.fullDocumentBackImage ?? "";
          _faceImageBase64 = result.faceImage ?? "";

          var identity = IdentificationMetaData();
          identity.documentFrontImage = _fullDocumentFrontImageBase64;
          identity.documentBackImage = _fullDocumentBackImageBase64;
          identity.documentFaceImage = _faceImageBase64;
        });
        IdentificationMetaData().docFaceImageBase64 = _faceImageBase64;

        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    scan();

    return MaterialApp(
        theme: Theme.of(context),
        home: Scaffold(
          appBar: AppBar(
            title: Center(child: Text(title)),
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  OcrResultForm(results: _result, faceImage: _faceImageBase64, theme: Theme.of(context)),
                  // fullDocumentFrontImage,
                  // fullDocumentBackImage,
                  // faceImage,
                ],
              )
          ),
        )
    );
  }
}
