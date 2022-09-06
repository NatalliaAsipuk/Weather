import 'package:flutter_config/flutter_config.dart';

class Environment {
  static final apiKey = FlutterConfig.get('API_KEY');
  static final languageCode = FlutterConfig.get('LANGUAGE_CODE');
}