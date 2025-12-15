import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class WithdrawFundsRepositoryInterface {
  Future<WithdrawFundsResponse> withdrawFunds({
    required int userId,
    required double amount,
  });
  
  Future<double> getUserBalance(int userId);
  Future<int?> getSavedUserId();
}

class WithdrawFundsResponse {
  final bool success;
  final String? message;
  final double? newBalance;

  WithdrawFundsResponse({
    required this.success,
    this.message,
    this.newBalance,
  });
}

class WithdrawFundsRepository implements WithdrawFundsRepositoryInterface {
  final Dio _dio;

  WithdrawFundsRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://cryptex-back.onrender.com/api',
                headers: {
                  'Content-Type': 'application/json',
                },
                connectTimeout: const Duration(seconds: 30),
                receiveTimeout: const Duration(seconds: 30),
              ),
            );

  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  @override
  Future<WithdrawFundsResponse> withdrawFunds({
    required int userId,
    required double amount,
  }) async {
    print('');
    print('═══════════════════════════════════════════');
    print('🔵 WITHDRAW FUNDS REQUEST STARTED');
    print('═══════════════════════════════════════════');
    print('📝 UserId: $userId');
    print('💰 Amount: \$$amount');
    
    try {
      final token = await _getToken();
      print('🔑 Token: ${token != null ? "✅ Present (${token.length} chars)" : "❌ Missing"}');
      
      if (token == null) {
        print('❌ No token found, cannot proceed');
        return WithdrawFundsResponse(
          success: false,
          message: 'Authentication token not found. Please login again.',
          newBalance: null,
        );
      }

      final url = '/user/$userId/withdraw';
      print('🌐 Request URL: $url');
      print('📦 Query params: {id: $userId, amount: $amount}');
      
      print('');
      print('⏳ Sending request...');

      final response = await _dio.post(
        url,
        queryParameters: {
          'id': userId,
          'amount': amount,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          validateStatus: (status) {
            // Приймаємо всі статуси для детального логування
            return status != null && status < 500;
          },
        ),
      );
      
      print('');
      print('═══════════════════════════════════════════');
      print('📥 RESPONSE RECEIVED');
      print('═══════════════════════════════════════════');
      print('📊 Status Code: ${response.statusCode}');
      print('📄 Response Type: ${response.data.runtimeType}');
      print('📝 Response Data: ${response.data}');
      print('═══════════════════════════════════════════');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Request successful!');
        
        // Отримуємо новий баланс
        print('');
        print('🔄 Fetching updated balance...');
        double? newBalance;
        
        try {
          newBalance = await getUserBalance(userId);
          print('✅ New balance fetched: \$$newBalance');
        } catch (e) {
          print('⚠️ Error fetching balance: $e');
          print('⚠️ Using calculated balance instead');
          // Якщо не вдалося отримати баланс, повертаємо null
          newBalance = null;
        }

        print('');
        print('✅ WITHDRAWAL COMPLETED SUCCESSFULLY');
        print('═══════════════════════════════════════════');
        
        return WithdrawFundsResponse(
          success: true,
          message: 'Withdrawal successful',
          newBalance: newBalance,
        );
      } else {
        print('❌ Request failed with status: ${response.statusCode}');
        return WithdrawFundsResponse(
          success: false,
          message: 'Server returned status ${response.statusCode}',
          newBalance: null,
        );
      }
      
    } on DioException catch (e) {
      print('');
      print('═══════════════════════════════════════════');
      print('❌ DIO EXCEPTION OCCURRED');
      print('═══════════════════════════════════════════');
      print('🔴 Error Type: ${e.type}');
      print('🔴 Status Code: ${e.response?.statusCode}');
      print('🔴 Response Data: ${e.response?.data}');
      print('🔴 Error Message: ${e.message}');
      print('🔴 Request Path: ${e.requestOptions.path}');
      print('═══════════════════════════════════════════');
      
      final errorMessage = _handleError(e);
      return WithdrawFundsResponse(
        success: false,
        message: errorMessage,
        newBalance: null,
      );
      
    } catch (e, stackTrace) {
      print('');
      print('═══════════════════════════════════════════');
      print('💥 UNEXPECTED ERROR OCCURRED');
      print('═══════════════════════════════════════════');
      print('🔴 Error: $e');
      print('🔴 Type: ${e.runtimeType}');
      print('📚 Stack Trace:');
      print(stackTrace);
      print('═══════════════════════════════════════════');
      
      return WithdrawFundsResponse(
        success: false,
        message: 'Unexpected error: ${e.toString()}',
        newBalance: null,
      );
    }
  }

  @override
  Future<double> getUserBalance(int userId) async {
    try {
      final token = await _getToken();
      
      if (token == null) {
        print('⚠️ No token for balance request');
        return 0.0;
      }
      
      final response = await _dio.get(
        '/user/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data != null && response.data['balance'] != null) {
        final balance = (response.data['balance'] as num).toDouble();
        return balance;
      }
      
      print('⚠️ No balance in response');
      return 0.0;
    } catch (e) {
      print('⚠️ Error getting balance: $e');
      return 0.0;
    }
  }

  @override
  Future<int?> getSavedUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('userId');
    } catch (e) {
      print('Error getting saved userId: $e');
      return null;
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
      if (data is String) {
        return data;
      }
      return 'Server error: ${e.response?.statusCode}';
    } else {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout. Please try again.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your internet.';
        case DioExceptionType.cancel:
          return 'Request cancelled.';
        default:
          return e.message ?? 'Network error';
      }
    }
  }
}