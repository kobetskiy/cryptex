import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DepositCryptoRepositoryInterface {
  Future<DepositCryptoResponse> depositCrypto({
    required int userId,
    required String depositAddress,
    required double amount,
  });
  
  Future<double> getUserCryptoBalance(int userId);
  Future<int?> getSavedUserId();
}

class DepositCryptoResponse {
  final bool success;
  final String? message;
  final double? newBalance;

  DepositCryptoResponse({
    required this.success,
    this.message,
    this.newBalance,
  });
}

class DepositCryptoRepository implements DepositCryptoRepositoryInterface {
  final Dio _dio;

  DepositCryptoRepository({Dio? dio})
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
  Future<DepositCryptoResponse> depositCrypto({
    required int userId,
    required String depositAddress,
    required double amount,
  }) async {
    print('');
    print('═══════════════════════════════════════════');
    print('🟢 DEPOSIT CRYPTO REQUEST');
    print('═══════════════════════════════════════════');
    print('UserId: $userId');
    print('Deposit Address: $depositAddress');
    print('Amount: $amount');
    
    try {
      final token = await _getToken();
      print('Token: ${token != null ? "✅ Present" : "❌ Missing"}');
      
      if (token == null) {
        return DepositCryptoResponse(
          success: false,
          message: 'Authentication token not found. Please login again.',
          newBalance: null,
        );
      }

      final response = await _dio.patch(
        '/user/$userId/deposit-crypto',
        queryParameters: {
          'userId': userId,
          'depositAddress': depositAddress,
          'amount': amount,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Crypto deposit successful!');
        
        // Отримуємо оновлений баланс
        final newBalance = await getUserCryptoBalance(userId);
        print('New crypto balance: $newBalance');

        return DepositCryptoResponse(
          success: true,
          message: 'Crypto deposit successful',
          newBalance: newBalance,
        );
      } else {
        return DepositCryptoResponse(
          success: false,
          message: 'Server returned status ${response.statusCode}',
          newBalance: null,
        );
      }
      
    } on DioException catch (e) {
      print('❌ DIO Error: ${e.response?.statusCode}');
      print('Error data: ${e.response?.data}');
      
      return DepositCryptoResponse(
        success: false,
        message: _handleError(e),
        newBalance: null,
      );
      
    } catch (e) {
      print('❌ Unexpected error: $e');
      return DepositCryptoResponse(
        success: false,
        message: 'Unexpected error: ${e.toString()}',
        newBalance: null,
      );
    }
  }

  @override
  Future<double> getUserCryptoBalance(int userId) async {
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

      // Припускаємо, що крипто баланс зберігається в полі cryptoBalance або balance
      if (response.data != null && response.data['cryptoBalance'] != null) {
        return (response.data['cryptoBalance'] as num).toDouble();
      }
      
      return 0.0;
    } catch (e) {
      print('Error getting crypto balance: $e');
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