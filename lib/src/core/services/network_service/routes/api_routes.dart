import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {
  ///
  /// Serving url
  ///
  static String get baseUrl => dotenv.get('BASE_URL');

  ///
  static const String login = '/auth/login';
}
