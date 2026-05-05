import 'package:dio/dio.dart';

import '../../../app/config.dart';

class HttpInit {
  static late final Dio dio;

  static Future<void> initialize() async {
    final baseUrl = AppConfig.instance.apiBaseUrl;

    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl.isNotEmpty ? baseUrl : 'https://api.example.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(LogInterceptor(responseBody: true));
  }
}
