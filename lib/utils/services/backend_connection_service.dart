import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test_tp21/model/IdentificationMetaData.dart';
import 'package:test_tp21/utils/services/secrets_manager_service.dart';

Future<bool> postUserVerification() async {
  var identity = IdentificationMetaData();

  final response = await http.post(
      Uri.parse(await getBackendUri() + '/app/verify'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(identity.toJson())
  );

  return response.statusCode == 200;
}

Future<bool> checkTokenValidity(uuid) async {
  final response = await http.get(
      Uri.parse(await getBackendUri() + "/app/check/" + uuid),
      headers: <String, String>{
        'Content-Type': 'application/json',
      }
  );

  if (response.statusCode == 200) {
    var result = jsonDecode(response.body);
    var identity = IdentificationMetaData();
    identity.personBackendData = result['companies'];

    return true;
  }

  return false;
}

Future<bool> verify(String img1, String img2) async {
  dynamic decodedJson = jsonDecode('{"person_foto":"img1","document_verification_photo":"img2"}');
  decodedJson['person_foto'] = 'data:image/jpeg;base64,' + img1;
  decodedJson['document_verification_photo'] = 'data:image/jpeg;base64,' + img2;

  var identity = IdentificationMetaData();
  return http.post(
    Uri.parse(await getBackendUri() + '/facecheck/' + identity.personUuid!),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Accept-Encoding': 'gzip, deflate, br',
    },
    body: jsonEncode(decodedJson),
  ).then((response) => faceCheckValidate(response));


}

bool faceCheckValidate(response) {
  try {
    final body = jsonDecode(response.body);
    return body['response'];
  } catch (exception) {
    print(exception.toString());
  }

  return false;
}
