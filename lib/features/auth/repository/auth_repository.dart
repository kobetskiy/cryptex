import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthRepository {
  final Dio _dio;

  AuthRepository({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(baseUrl: 'https://cryptex-back.onrender.com/api/auth'),
          );

  Future<int?> signUp({
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

      print('SignUp Response: ${response.data}');
      print('Response type: ${response.data.runtimeType}');

      String? token;
      
      if (response.data is String) {
        token = response.data;
      } else if (response.data is Map) {
        token = response.data['token'] ?? 
                response.data['accessToken'] ?? 
                response.data['access_token'];
      }

      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        
        // Декодуємо токен і витягуємо userId
        final userId = _extractUserIdFromToken(token);
        if (userId != null) {
          await prefs.setInt('userId', userId);
        }
        return userId;
      } else {
        throw Exception('Token not found in response');
      }
    } on DioException catch (e) {
      print('SignUp Error: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');
      throw Exception(_handleError(e));
    }
  }

  Future<int?> logIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.patch(
        '/login',
        data: {'email': email, 'password': password},
      );

      print('Login Response: ${response.data}');
      print('Response type: ${response.data.runtimeType}');

      String? token;
      
      if (response.data is String) {
        token = response.data;
      } else if (response.data is Map) {
        token = response.data['token'] ?? 
                response.data['accessToken'] ?? 
                response.data['access_token'];
      }

      if (token != null && token.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        
        // Декодуємо токен і витягуємо userId
        final userId = _extractUserIdFromToken(token);
        if (userId != null) {
          await prefs.setInt('userId', userId);
        }
        return userId;
      } else {
        throw Exception('Token not found in response');
      }
    } on DioException catch (e) {
      print('Login Error: ${e.response?.data}');
      print('Status Code: ${e.response?.statusCode}');
      throw Exception(_handleError(e));
    }
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  // Метод для отримання збереженого userId
  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  // Декодування JWT і витягування userId
  int? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Invalid JWT token format');
        return null;
      }

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      final payloadMap = json.decode(decoded);
      
      print('Decoded JWT payload: $payloadMap');
      
      // Можливі варіанти назв поля з userId
      final userId = payloadMap['Id'] ??       // ⬅️ Додано з великої літери!
                   payloadMap['id'] ?? 
                   payloadMap['userId'] ?? 
                   payloadMap['user_id'] ??
                   payloadMap['UserId'] ??   // ⬅️ Додано варіант
                   payloadMap['sub'];
      
      if (userId != null) {
        print('Extracted userId: $userId');
        return userId is int ? userId : int.tryParse(userId.toString());
      }
      
      print('userId not found in token');
      return null;
    } catch (e) {
      print('Error decoding JWT: $e');
      return null;
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
      return data.toString();
    } else {
      return e.message ?? 'Network error';
    }
  }
}