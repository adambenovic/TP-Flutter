import 'package:flutter_dotenv/flutter_dotenv.dart';

const BLINK_ID_KEY = 'BLINK_ID_KEY';
const BE_URI = 'BE_URI';

Future<void> _checkOrLoadEnv() async {
  if (!dotenv.isInitialized) {
    await dotenv.load(fileName: 'keys.env');
    await dotenv.load(fileName: '.env',mergeWith: Map.from(dotenv.env));
  }
}

Future<String> _getKey(String key) async {
  await _checkOrLoadEnv();
  var value = dotenv.env[key];
  if (value == null) {
    throw Exception("key: " + key + " is missing in corresponding env file");
  }
  return value;
}

Future<String> getBlinkIDKey() async {
  return _getKey(BLINK_ID_KEY);
}

Future<String> getBackendUri() async {
  return _getKey(BE_URI);
}
