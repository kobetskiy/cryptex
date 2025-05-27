import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: 'http://localhost:5000/api/auth'));

  Future<Response> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        '/registration',
        data: {
          "googleID": "",
          "email": email,
          "name": name,
          "surname": "",
          "phoneNumber": "",
          "age": 0,
          "country": "",
          "adress": "",
          "password": password,
          "role": "0",
        },
      );

      final token = response.data['data'];
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }

      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<Response> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final token = response.data;
      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }

      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data.toString() ?? 'Unknown error';
    } else {
      return e.message ?? 'Network error';
    }
  }
}
