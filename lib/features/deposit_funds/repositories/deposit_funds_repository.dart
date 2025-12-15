import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DepositFundsRepositoryInterface {
  Future<DepositFundsResponse> depositFunds({
    required int userId,
    required double amount,
  });
  
  Future<double> getUserBalance(int userId);
  Future<int?> getSavedUserId();
}

class DepositFundsResponse {
  final bool success;
  final String? message;
  final double? newBalance;

  DepositFundsResponse({
    required this.success,
    this.message,
    this.newBalance,
  });
}

class DepositFundsRepository implements DepositFundsRepositoryInterface {
  final Dio _dio;

  DepositFundsRepository({Dio? dio})
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
  Future<DepositFundsResponse> depositFunds({
    required int userId,
    required double amount,
  }) async {
    print('');
    print('═══════════════════════════════════════════');
    print('🟢 DEPOSIT FUNDS REQUEST');
    print('═══════════════════════════════════════════');
    print('UserId: $userId');
    print('Amount: \$$amount');
    
    try {
      final token = await _getToken();
      print('Token: ${token != null ? "✅ Present" : "❌ Missing"}');
      
      if (token == null) {
        return DepositFundsResponse(
          success: false,
          message: 'Authentication token not found. Please login again.',
          newBalance: null,
        );
      }

      final response = await _dio.patch(
        '/user/$userId/deposit',
        queryParameters: {
          'userId': userId,
          'amount': amount,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Deposit successful!');
        
        // Отримуємо оновлений баланс
        final newBalance = await getUserBalance(userId);
        print('New balance: \$$newBalance');

        return DepositFundsResponse(
          success: true,
          message: 'Deposit successful',
          newBalance: newBalance,
        );
      } else {
        return DepositFundsResponse(
          success: false,
          message: 'Server returned status ${response.statusCode}',
          newBalance: null,
        );
      }
      
    } on DioException catch (e) {
      print('❌ DIO Error: ${e.response?.statusCode}');
      print('Error data: ${e.response?.data}');
      
      return DepositFundsResponse(
        success: false,
        message: _handleError(e),
        newBalance: null,
      );
      
    } catch (e) {
      print('❌ Unexpected error: $e');
      return DepositFundsResponse(
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
        return 0.0;
      }
      
      final response = await _dio.get(
        '/user/$userId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data != null && response.data['balance'] != null) {
        return (response.data['balance'] as num).toDouble();
      }
      
      return 0.0;
    } catch (e) {
      print('Error getting balance: $e');
      return 0.0;
    }
  }

  @override
  Future<int?> getSavedUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt('userId');
    } catch (e) {
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
      return 'Network error. Please check your internet connection.';
    }
  }
}