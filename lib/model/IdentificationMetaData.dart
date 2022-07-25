import 'package:test_tp21/model/enums/DocType.dart';

class IdentificationMetaData{
  static final IdentificationMetaData _singleton = IdentificationMetaData._internal();
  DocType? expectedDocType;
  List<dynamic> personBackendData = [];
  String docFaceImageBase64 = '';
  String documentFrontImage = '';
  String documentBackImage = '';
  String documentFaceImage = '';
  String name = '';
  String surname = '';
  String address = '';
  String documentNumber = '';
  String gender = '';
  String issuingAuthority = '';
  String nationality = '';
  String dateOfBirth = '';
  String age = '';
  String dateOfIssue = '';
  String dateOfExpiry = '';
  String personalIdNumber = '';
  String documentType = '';
  String? personUuid;

  factory IdentificationMetaData() {
    return _singleton;
  }

  IdentificationMetaData._internal();

  dynamic toJson() {
    return {
      "id": personUuid,
      "name": name,
      "surname": surname,
      "country": address,
      "id_number": personalIdNumber,
      "document_type": documentType,
      "document_number": documentNumber,
      "address": {
        "city": address,
        "street": address,
        "number": address
      },
      "document_front": 'data:image/jpeg;base64,' + documentFrontImage,
      "document_back": 'data:image/jpeg;base64,' + documentBackImage,
      "document_verification_photo": 'data:image/jpeg;base64,' + documentFaceImage
    };
  }
}
