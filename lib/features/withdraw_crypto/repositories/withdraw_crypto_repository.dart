import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../buy_crypto/models/crypto_coin.dart';

abstract class WithdrawCryptoRepositoryInterface {
  Future<WithdrawCryptoResponse> withdrawCrypto({
    required int userId,
    required int coinName,
    required double amount,
    required String externalAddress,
  });
  
  Future<Map<String, double>> getCryptoPrices();
  Future<double> getCoinPrice(int coinId);
  Future<double> getUserBalance(int userId);
  Future<Map<int, double>> getUserCryptoBalances(int userId);
  Future<int?> getSavedUserId();
}

class WithdrawCryptoResponse {
  final bool success;
  final String? message;
  final double? newBalance;
  final Map<int, double>? cryptoBalances;

  WithdrawCryptoResponse({
    required this.success,
    this.message,
    this.newBalance,
    this.cryptoBalances,
  });

  factory WithdrawCryptoResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawCryptoResponse(
      success: json['success'] ?? true,
      message: json['message'],
      newBalance: json['newBalance']?.toDouble(),
    );
  }
}

class WithdrawCryptoRepository implements WithdrawCryptoRepositoryInterface {
  final Dio _dio;

  WithdrawCryptoRepository({Dio? dio})
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
  Future<WithdrawCryptoResponse> withdrawCrypto({
    required int userId,
    required int coinName,
    required double amount,
    required String externalAddress,
  }) async {
    print('');
    print('═══════════════════════════════════════════');
    print('🟢 WITHDRAW CRYPTO REQUEST');
    print('═══════════════════════════════════════════');
    print('UserId: $userId');
    print('Coin: $coinName');
    print('Amount: $amount');
    print('External Address: $externalAddress');
    
    try {
      final token = await _getToken();
      print('Token: ${token != null ? "✅ Present" : "❌ Missing"}');
      
      if (token == null) {
        return WithdrawCryptoResponse(
          success: false,
          message: 'Authentication token not found. Please login again.',
        );
      }

      final response = await _dio.post(
        '/user/$userId/withdraw-crypto',
        queryParameters: {
          'userid': userId,
          'coinname': coinName,
          'amount': amount,
          'externalAddress': externalAddress,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      
      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      print('Response Data Type: ${response.data.runtimeType}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Withdraw successful!');
        
        // Якщо response.data є String (текстове повідомлення), просто повертаємо success
        if (response.data is String) {
          print('Response is a string message, fetching updated balances...');
          
          // Завантажуємо оновлені баланси окремим запитом
          final updatedBalances = await getUserCryptoBalances(userId);
          final updatedUserBalance = await getUserBalance(userId);
          
          return WithdrawCryptoResponse(
            success: true,
            message: 'Withdrawal successful',
            newBalance: updatedUserBalance,
            cryptoBalances: updatedBalances,
          );
        }
        
        // Якщо response.data є Map (JSON об'єкт)
        final newBalance = response.data['balance']?.toDouble();
        final cryptoBalances = <int, double>{};
        
        final wallet = response.data['wallet'];
        if (wallet != null && wallet['amountOfCoins'] != null) {
          final coins = wallet['amountOfCoins'] as List;
          print('Updated crypto balances after withdrawal:');
          for (var coinData in coins) {
            final coinId = coinData['name'] as int;
            final coinAmount = (coinData['amount'] as num).toDouble();
            cryptoBalances[coinId] = coinAmount;
            print('  - Coin $coinId: $coinAmount');
          }
        }
        
        return WithdrawCryptoResponse(
          success: true,
          message: 'Withdrawal successful',
          newBalance: newBalance,
          cryptoBalances: cryptoBalances,
        );
      }

      return WithdrawCryptoResponse(
        success: false,
        message: 'Server returned status ${response.statusCode}',
      );
    } on DioException catch (e) {
      print('❌ DIO Error: ${e.response?.statusCode}');
      print('Error data: ${e.response?.data}');
      
      return WithdrawCryptoResponse(
        success: false,
        message: _handleError(e),
      );
    } catch (e) {
      print('❌ Unexpected error: $e');
      return WithdrawCryptoResponse(
        success: false,
        message: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  @override
  Future<double> getCoinPrice(int coinId) async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '/coin/price-history',
        queryParameters: {
          'Coin': coinId,
          'PeriodOfTime': 0,
        },
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      print('📊 Price response for coin $coinId: ${response.data}');

      if (response.data is List) {
        final priceList = response.data as List;
        
        if (priceList.isEmpty) {
          print('⚠️ Empty price list for coin $coinId');
          return 0.0;
        }
        
        final lastPrice = priceList.last;
        final price = (lastPrice as num).toDouble();
        print('✅ Coin $coinId price: \$$price');
        return price;
      }
      print('⚠️ Unexpected response format for coin $coinId');
      return 0.0;
    } on DioException catch (e) {
      print('❌ Error getting coin $coinId price: ${e.message}');
      return 0.0;
    } catch (e) {
      print('❌ Unexpected error getting coin $coinId price: $e');
      return 0.0;
    }
  }

  @override
  Future<Map<String, double>> getCryptoPrices() async {
    print('');
    print('═══════════════════════════════════════════');
    print('💰 LOADING CRYPTO PRICES');
    print('═══════════════════════════════════════════');
    
    try {
      final prices = <String, double>{};
      
      for (final coin in CryptoCoin.values) {
        try {
          print('Fetching price for ${coin.name} (${coin.symbol})...');
          final price = await getCoinPrice(coin.id);
          prices[coin.symbol] = price;
          print('  ✅ ${coin.symbol}: \$$price');
        } catch (e) {
          print('  ❌ Error fetching price for ${coin.symbol}: $e');
          prices[coin.symbol] = 0.0;
        }
      }

      print('');
      print('Final prices map: $prices');
      print('═══════════════════════════════════════════');
      return prices;
    } catch (e) {
      print('❌ Error fetching crypto prices: $e');
      return {};
    }
  }

  @override
  Future<double> getUserBalance(int userId) async {
    try {
      final token = await _getToken();
      
      final response = await _dio.get(
        '/user/$userId',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      if (response.data != null && response.data['balance'] != null) {
        final balance = (response.data['balance'] as num).toDouble();
        print('💵 User balance: \$$balance');
        return balance;
      }
      
      return 0.0;
    } catch (e) {
      print('Error getting user balance: $e');
      return 0.0;
    }
  }

  @override
  Future<Map<int, double>> getUserCryptoBalances(int userId) async {
    print('');
    print('═══════════════════════════════════════════');
    print('🪙 LOADING USER CRYPTO BALANCES');
    print('═══════════════════════════════════════════');
    
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '/user/$userId',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      print('User response: ${response.data}');

      final balances = <int, double>{};
      
      final wallet = response.data['wallet'];
      if (wallet != null && wallet['amountOfCoins'] != null) {
        final coins = wallet['amountOfCoins'] as List;
        print('Coins in wallet:');
        for (var coinData in coins) {
          print('  Coin data: $coinData');
          final coinId = coinData['name'] as int;
          final amount = (coinData['amount'] as num).toDouble();
          balances[coinId] = amount;
          print('  ✅ Coin $coinId balance: $amount');
        }
      }
      
      print('Final balances: $balances');
      print('═══════════════════════════════════════════');
      return balances;
    } catch (e) {
      print('❌ Error getting crypto balances: $e');
      print('Error type: ${e.runtimeType}');
      if (e is TypeError) {
        print('TypeError details: $e');
      }
      return {};
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