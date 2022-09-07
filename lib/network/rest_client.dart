import 'dart:async';
import 'package:dio/dio.dart';
import 'package:dio_flutter_transformer/dio_flutter_transformer.dart';
import 'endpoints.dart';


class RestClient {
  Dio _dio;

  static final RestClient _client = RestClient._internal();

  factory RestClient() => _client;

  RestClient._internal() {
    _dio = new Dio();
    _dio.options.baseUrl = Endpoints.server;
    _dio.options.connectTimeout = 20000;
    _dio.options.receiveTimeout = 10000;
    _dio.transformer = FlutterTransformer();
    _dio.interceptors.add(EnvironmentManager());
  }

  Future<dynamic> get(String url, {Map<String, dynamic> match = const {}, String paramsString = ''}) async
  {
    try {
      final response = await _dio.get(url+paramsString, queryParameters: match);
      return response.data;
    } on DioError catch (e) {
      return throw e;
    }
  }
}

class EnvironmentManager extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    options.baseUrl = Endpoints.server;
  }
}
