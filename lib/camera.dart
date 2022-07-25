import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:test_tp21/conf/conf.dart';
import 'package:test_tp21/face_capture_success.dart';
import 'package:test_tp21/utils/services/backend_connection_service.dart';

import 'model/IdentificationMetaData.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickImageError;
  String? _retrieveDataError;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Theme.of(context),
        home: LoaderOverlay(
          child: Scaffold(
            key: _scaffoldKey,
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
                                'In order to identify you as a last step we need to verify you with the help of facial recognition.',
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
                        imageSelector(context);
                      },
                      child: Text('Continue'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }

  Future imageSelector(BuildContext context) async {
    bool verified = false;

    final XFile? imageFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: faceImageMaxWidth,
        maxHeight: faceImageMaxHeight,
        imageQuality: faceImageQuality,
        preferredCameraDevice: CameraDevice.front
    );

    context.loaderOverlay.show();

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await retrieveLostData();
    }

    if (imageFile != null && File(imageFile.path).existsSync()) {
      setState(() async {

        String base64Image = base64Encode(File(imageFile.path).readAsBytesSync());

        verified = await verify(base64Image, IdentificationMetaData().docFaceImageBase64);
        context.loaderOverlay.hide();

        if (verified) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FaceCaptureSuccess()),
          );
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text("Could not verify you. Please, try again."),
              )
          );
        }
      });
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }
}
