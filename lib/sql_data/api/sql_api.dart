
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class SqlApi{
  final Dio _dio = Dio();

  SqlApi() {
    _dio.options.baseUrl = "http://192.168.1.34:3001/";
    _dio.interceptors.add(PrettyDioLogger());
  }

  Dio get sendRequest => _dio;

}