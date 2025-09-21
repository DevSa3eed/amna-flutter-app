import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://petfinder-sub.ae.pet-finder.ae/api/',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> post({
    required String url,
    FormData? data,
    Map<String, dynamic>? query,
  }) async {
    return await dio!.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? qurey,
  }) async {
    return await dio!.get(
      url,
      queryParameters: qurey,
    );
  }

  static Future<Response> put({
    required String url,
    FormData? data,
    Map<String, dynamic>? query,
  }) async {
    return await dio!.put(
      url,
      // data: data,
      queryParameters: query,
    );
  }

  static Future<Response> delete({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio!.delete(
      url,
      queryParameters: query,
    );
  }
}
