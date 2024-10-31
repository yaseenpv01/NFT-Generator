import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get stabilityApiKey => dotenv.env['STABILITY_API_KEY'] ?? '';

  static bool get hasValidApiKey => stabilityApiKey.isNotEmpty;
}