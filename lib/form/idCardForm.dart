import 'package:blinkid_flutter/microblink_scanner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_tp21/camera.dart';
import 'package:test_tp21/model/IdentificationMetaData.dart';

class OcrResultForm extends StatefulWidget {
  final BlinkIdCombinedRecognizerResult results;
  final ThemeData theme;
  final String faceImage;

  const OcrResultForm({Key? key, required this.results, required this.faceImage, required this.theme}) : super(key: key);

  @override
  OcrResultFormState createState() {
    return OcrResultFormState();
  }
}

class OcrResultFormState extends State<OcrResultForm> {
  final _formKey = GlobalKey<FormState>();
  IdentificationMetaData identity = IdentificationMetaData();

  Future<DateTime> _selectDate(BuildContext context, DateTime selectedDate, DateTime firstDate, DateTime lastDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });

    return selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> resultList = [];
    if (widget.results.mrzResult?.documentType == MrtdDocumentType.Passport) {
      resultList = getPassportResultAsFormFields(widget.results);
    } else {
      resultList = getIdResultsAsFormFields(widget.results);
    }

    resultList.add(ElevatedButton(
      style: widget.theme.elevatedButtonTheme.style,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Entered data not valid, please update invalid fields'),
                backgroundColor: Colors.red
            ),
          );
        }
      },
      child: const Text('Confirm'),
    ));

    return Form(
      key: _formKey,
      child: Column(
        children: resultList,
      ),
    );
  }

  List<Widget> getIdResultsAsFormFields(BlinkIdCombinedRecognizerResult result) {
    List<Widget> list = [];
    identity.documentType = 'op';

    if(identity.name.isEmpty) {
      identity.name = buildResult(result.firstName);
    }

    if(identity.surname.isEmpty) {
      identity.surname = buildResult(result.lastName);
    }

    if(identity.address.isEmpty) {
      identity.address = buildResult(result.address);
    }

    if(identity.documentNumber.isEmpty) {
      identity.documentNumber = buildResult(result.documentNumber);
    }

    if(identity.gender.isEmpty) {
      identity.gender = buildResult(result.sex);
    }

    if(identity.issuingAuthority.isEmpty) {
      identity.issuingAuthority = buildResult(result.issuingAuthority);
    }

    if(identity.nationality.isEmpty) {
      identity.nationality = buildResult(result.nationality);
    }

    if(identity.dateOfBirth.isEmpty) {
      identity.dateOfBirth = buildDateResult(result.dateOfBirth);
    }

    if(identity.dateOfIssue.isEmpty) {
      identity.dateOfIssue = buildDateResult(result.dateOfIssue);
    }

    if(identity.dateOfExpiry.isEmpty) {
      identity.dateOfExpiry = buildDateResult(result.dateOfExpiry);
    }

    if(identity.personalIdNumber.isEmpty) {
      identity.personalIdNumber = buildResult(result.personalIdNumber);
    }

    TextEditingController nameController = TextEditingController(text: identity.name);
    nameController.addListener(() {identity.name = nameController.text;});
    TextEditingController surnameController = TextEditingController(text: identity.surname);
    surnameController.addListener(() {identity.surname = surnameController.text;});
    TextEditingController addressController = TextEditingController(text: identity.address);
    addressController.addListener(() {identity.address = addressController.text;});
    TextEditingController documentNumberController = TextEditingController(text: identity.documentNumber);
    documentNumberController.addListener(() {identity.documentNumber = documentNumberController.text;});
    TextEditingController issuingAuthorityController = TextEditingController(text: identity.issuingAuthority);
    issuingAuthorityController.addListener(() {identity.issuingAuthority = issuingAuthorityController.text;});
    TextEditingController nationalityController = TextEditingController(text: identity.nationality);
    nationalityController.addListener(() {identity.nationality = nationalityController.text;});
    TextEditingController dateOfBirthController = TextEditingController(text: identity.dateOfBirth);
    dateOfBirthController.addListener(() {identity.dateOfBirth = dateOfBirthController.text;});
    TextEditingController ageController = TextEditingController(text: buildAge(identity.dateOfBirth));
    ageController.addListener(() {identity.age = ageController.text;});
    TextEditingController dateOfIssueController = TextEditingController(text: identity.dateOfIssue);
    dateOfIssueController.addListener(() {identity.dateOfIssue = dateOfIssueController.text;});
    TextEditingController dateOfExpiryController = TextEditingController(text: identity.dateOfExpiry);
    dateOfExpiryController.addListener(() {identity.dateOfExpiry = dateOfExpiryController.text;});
    TextEditingController personalIdNumberController = TextEditingController(text: identity.personalIdNumber);
    personalIdNumberController.addListener(() {identity.personalIdNumber = personalIdNumberController.text;});

    list.add(TextFormField(
      controller: nameController,
      decoration: const InputDecoration(
        labelText: 'First name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter first name';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: surnameController,
      decoration: const InputDecoration(
        labelText: 'Last name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter last name';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: addressController,
      decoration: const InputDecoration(
        labelText: 'Address',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter address';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: documentNumberController,
      decoration: const InputDecoration(
        labelText: 'Document number',
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty && value.length < 6) {
          return 'Entered number is too short.';
        }

        if (value == null || value.isEmpty) {
          return 'Enter document number';
        }

        return null;
      },
    ));

    list.add(DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Sex',
      ),
      value: identity.gender,
      onChanged: (String? newValue) {
        setState(() {
          identity.gender = newValue!;
        });
      },
      items: <String>['M', 'F']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter sex';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: issuingAuthorityController,
      decoration: const InputDecoration(
        labelText: 'Issuing authority',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter issuing authority';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: nationalityController,
      decoration: const InputDecoration(
        labelText: 'Nationality',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter nationality';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: dateOfBirthController,
      readOnly: true,
      onTap: () async {
        final date = await _selectDate(context, DateTime.utc(result.dateOfBirth!.year!, result.dateOfBirth!.month!, result.dateOfBirth!.day!),  DateTime(1900), DateTime.now());
        identity.dateOfBirth = "${date.day}.${date.month}.${date.year}";
      },
      decoration: const InputDecoration(
        labelText: 'Date of birth',
      ),
    ));

    list.add(TextFormField(
      controller: ageController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Age',
      ),
    ));

    list.add(TextFormField(
      controller: dateOfIssueController,
      readOnly: true,
      onTap: () async {
        final date = await _selectDate(context, DateTime.utc(result.dateOfIssue!.year!, result.dateOfIssue!.month!, result.dateOfIssue!.day!),  DateTime(1900), DateTime.now());
        identity.dateOfIssue = "${date.day}.${date.month}.${date.year}";
      },
      decoration: const InputDecoration(
        labelText: 'Date of issue',
      ),
    ));

    list.add(TextFormField(
      controller: dateOfExpiryController,
      readOnly: true,
      onTap: () async {
        final date = await _selectDate(context, DateTime.utc(result.dateOfExpiry!.year!, result.dateOfExpiry!.month!, result.dateOfExpiry!.day!),  DateTime.now(), DateTime(2120));
        identity.dateOfExpiry = "${date.day}.${date.month}.${date.year}";
      },
      decoration: const InputDecoration(
        labelText: 'Date of expiry',
      ),
    ));

    list.add(TextFormField(
      controller: personalIdNumberController,
      decoration: const InputDecoration(
        labelText: 'Personal Id Number',
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return validatePID(value);
        }

        return null;
      },
    ));

    return list;
  }

  String? validatePID(String value) {
    value = value.replaceAll('/', '');
    if (value.length < 9) {
      return 'Personal id number is too short';
    }

    if (value.length > 10) {
      return 'Personal id number is too long';
    }

    if (value.length == 9 && int.parse(value.substring(0, 2)) > 53) {
      return 'Personal id number is not valid(9 characters long should have year at most 53)';
    }

    if (value.length == 10 && int.parse(value) % 11 != 0) {
      return 'Personal id number is not valid(modulo by 11 is not 0)';
    }

    return null;
  }

  String buildAge(String? birthDateString) {
    String age = '';
    if (birthDateString != null && birthDateString.isNotEmpty) {
      DateTime currentDate = DateTime.now();
      DateTime birthDate = DateFormat("d.M.y").parse(birthDateString);
      int intAge = currentDate.year - birthDate.year;
      if (birthDate.month > currentDate.month) {
        intAge--;
      } else if (currentDate.month == birthDate.month && birthDate.day > currentDate.day) {
        intAge--;
      }

      age = intAge.toString();
    }

    return age;
  }

  String buildResult(String? result) {
    if (result == null || result.isEmpty) {
      return "";
    }

    return result.replaceAll("\n", ' ');
  }

  String buildDateResult(Date? result) {
    if (result == null || result.year == 0) {
      return "";
    }

    return buildResult("${result.day}.${result.month}.${result.year}");
  }

  String buildIntResult(int? result) {
    if (result == null || result < 0) {
      return "";
    }

    return buildResult(result.toString());
  }

  List<Widget> getPassportResultAsFormFields(BlinkIdCombinedRecognizerResult? result) {
    List<Widget> list = [];

    if(result == null) {
      return [];
    }

    IdentificationMetaData identity = IdentificationMetaData();
    identity.documentType = 'pass';

    if(identity.name.isEmpty) {
      identity.name = "${result.mrzResult?.secondaryId}";
    }

    if(identity.surname.isEmpty) {
      identity.surname = "${result.mrzResult?.primaryId}";
    }

    if(identity.documentNumber.isEmpty) {
      identity.documentNumber = "${result.mrzResult?.documentNumber}";
    }

    if(identity.gender.isEmpty) {
      identity.gender = "${result.mrzResult?.gender}";
    }

    if(identity.issuingAuthority.isEmpty) {
      identity.issuingAuthority = "${result.mrzResult?.issuer}";
    }

    if(identity.nationality.isEmpty) {
      identity.nationality = "${result.mrzResult?.nationality}";
    }

    if(identity.dateOfBirth.isEmpty) {
      identity.dateOfBirth = buildDateResult(result.dateOfBirth);
    }

    if(identity.dateOfIssue.isEmpty) {
      identity.dateOfIssue = buildDateResult(result.dateOfIssue);
    }

    if(identity.dateOfExpiry.isEmpty) {
      identity.dateOfExpiry = buildDateResult(result.dateOfExpiry);
    }

    if(identity.personalIdNumber.isEmpty) {
      identity.personalIdNumber = buildResult(result.personalIdNumber);
    }

    TextEditingController nameController = TextEditingController(text: identity.name);
    nameController.addListener(() {identity.name = nameController.text;});
    TextEditingController surnameController = TextEditingController(text: identity.surname);
    surnameController.addListener(() {identity.surname = surnameController.text;});
    TextEditingController addressController = TextEditingController(text: identity.address);
    addressController.addListener(() {identity.address = addressController.text;});
    TextEditingController documentNumberController = TextEditingController(text: identity.documentNumber);
    documentNumberController.addListener(() {identity.documentNumber = documentNumberController.text;});
    TextEditingController issuingAuthorityController = TextEditingController(text: identity.issuingAuthority);
    issuingAuthorityController.addListener(() {identity.issuingAuthority = issuingAuthorityController.text;});
    TextEditingController nationalityController = TextEditingController(text: identity.nationality);
    nationalityController.addListener(() {identity.nationality = nationalityController.text;});
    TextEditingController dateOfBirthController = TextEditingController(text: identity.dateOfBirth);
    dateOfBirthController.addListener(() {identity.dateOfBirth = dateOfBirthController.text;});
    TextEditingController ageController = TextEditingController(text: buildAge(identity.dateOfBirth));
    ageController.addListener(() {identity.age = ageController.text;});
    TextEditingController dateOfIssueController = TextEditingController(text: identity.dateOfIssue);
    dateOfIssueController.addListener(() {identity.dateOfIssue = dateOfIssueController.text;});
    TextEditingController dateOfExpiryController = TextEditingController(text: identity.dateOfExpiry);
    dateOfExpiryController.addListener(() {identity.dateOfExpiry = dateOfExpiryController.text;});
    TextEditingController personalIdNumberController = TextEditingController(text: identity.personalIdNumber);
    personalIdNumberController.addListener(() {identity.personalIdNumber = personalIdNumberController.text;});

    list.add(TextFormField(
      controller: nameController,
      decoration: const InputDecoration(
        labelText: 'First name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter first name';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: surnameController,
      decoration: const InputDecoration(
        labelText: 'Last name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter last name';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: addressController,
      decoration: const InputDecoration(
        labelText: 'Address',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter address';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: documentNumberController,
      decoration: const InputDecoration(
        labelText: 'Document number',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter document number';
        }

        if (value.length < 6) {
          return 'Entered number is too short.';
        }

        return null;
      },
    ));

    list.add(DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Sex',
      ),
      value: identity.gender,
      onChanged: (String? newValue) {
        setState(() {
          identity.gender = newValue!;
        });
      },
      items: <String>['M', 'F']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter sex';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: issuingAuthorityController,
      decoration: const InputDecoration(
        labelText: 'Issuing authority',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter issuing authority';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: nationalityController,
      decoration: const InputDecoration(
        labelText: 'Nationality',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter nationality';
        }

        return null;
      },
    ));

    list.add(TextFormField(
      controller: dateOfBirthController,
      readOnly: true,
      onTap: () async {
        final date = await _selectDate(context, DateTime.utc(result.mrzResult!.dateOfBirth!.year!, result.mrzResult!.dateOfBirth!.month!, result.mrzResult!.dateOfBirth!.day!),  DateTime(1900), DateTime.now());
        identity.dateOfBirth = "${date.day}.${date.month}.${date.year}";
      },
      decoration: const InputDecoration(
        labelText: 'Date of birth',
      ),
    ));

    list.add(TextFormField(
      controller: ageController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Age',
      ),
    ));

    list.add(TextFormField(
      controller: dateOfExpiryController,
      readOnly: true,
      onTap: () async {
        final date = await _selectDate(context, DateTime.utc(result.mrzResult!.dateOfExpiry!.year!, result.mrzResult!.dateOfExpiry!.month!, result.mrzResult!.dateOfExpiry!.day!),  DateTime.now(), DateTime(2120));
        identity.dateOfExpiry = "${date.day}.${date.month}.${date.year}";
      },
      decoration: const InputDecoration(
        labelText: 'Date of expiry',
      ),
    ));

    return list;
  }
}
