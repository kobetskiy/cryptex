import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/crypto_coin.dart';

abstract class BuyCryptoRepositoryInterface {
  Future<BuyCryptoResponse> buyCrypto({
    required int userId,
    required int coin,
    required double amount,
  });
  
  Future<Map<String, double>> getCryptoPrices();
  Future<double> getCoinPrice(int coinId);
  Future<double> getUserBalance(int userId); // Додати
  Future<Map<int, double>> getUserCryptoBalances(int userId); // Додати
}

class BuyCryptoResponse {
  final bool success;
  final String? message;
  final double? newBalance;
  final double? cryptoAmount;

  BuyCryptoResponse({
    required this.success,
    this.message,
    this.newBalance,
    this.cryptoAmount,
  });

  factory BuyCryptoResponse.fromJson(Map<String, dynamic> json) {
    return BuyCryptoResponse(
      success: json['success'] ?? true,
      message: json['message'],
      newBalance: json['newBalance']?.toDouble(),
      cryptoAmount: json['cryptoAmount']?.toDouble(),
    );
  }
}

class BuyCryptoRepository implements BuyCryptoRepositoryInterface {
  final Dio _dio;

  BuyCryptoRepository({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: 'https://cryptex-back.onrender.com/api',
                headers: {
                  'Content-Type': 'application/json',
                },
              ),
            );

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

 @override
Future<BuyCryptoResponse> buyCrypto({
  required int userId,
  required int coin,
  required double amount,
}) async {
  try {
    final token = await _getToken();
    
    print('===========================================');
    print('=== BUY CRYPTO REQUEST ===');
    print('URL: ${_dio.options.baseUrl}/user/$userId/wallet/buy');
    print('Method: POST');
    print('Query Parameters: id=$userId, coin=$coin, amount=$amount');
    print('Token present: ${token != null}');
    print('===========================================');
    
    final response = await _dio.post(
      '/user/$userId/wallet/buy',
      queryParameters: {  // ⬅️ Змінено з data на queryParameters!
        'id': userId,
        'coin': coin,
        'amount': amount,
      },
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );

    print('===========================================');
    print('=== BUY CRYPTO RESPONSE ===');
    print('Status Code: ${response.statusCode}');
    print('New Balance: ${response.data['balance']}');
    
    final wallet = response.data['wallet'];
    if (wallet != null && wallet['amountOfCoins'] != null) {
      final coins = wallet['amountOfCoins'] as List;
      print('Coins in wallet:');
      for (var coinData in coins) {
        print('  - Coin ${coinData['name']}: amount=${coinData['amount']} (price: \$${coinData['price']})');
      }
    }
    print('===========================================');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final newBalance = response.data['balance']?.toDouble();
      
      double? cryptoAmount;
      if (wallet != null && wallet['amountOfCoins'] != null) {
        final coins = wallet['amountOfCoins'] as List;
        final boughtCoin = coins.firstWhere(
          (c) => c['name'] == coin,
          orElse: () => null,
        );
        if (boughtCoin != null) {
          cryptoAmount = boughtCoin['amount']?.toDouble();
        }
      }
      
      return BuyCryptoResponse(
        success: true,
        message: 'Purchase successful',
        newBalance: newBalance,
        cryptoAmount: cryptoAmount,
      );
    }

    return BuyCryptoResponse(
      success: false,
      message: 'Purchase failed',
    );
  } on DioException catch (e) {
    print('===========================================');
    print('=== BUY CRYPTO ERROR ===');
    print('Status Code: ${e.response?.statusCode}');
    print('Error Response: ${e.response?.data}');
    print('===========================================');
    
    throw Exception(_handleError(e));
  }
}

  @override
Future<double> getCoinPrice(int coinId) async {
  try {
    final token = await _getToken(); // Додаємо токен
    
    print('=== Get Coin Price Request ===');
    print('Coin: $coinId');
    print('Token: ${token != null ? "Present (${token.substring(0, 20)}...)" : "Missing"}');
    
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

    print('Price Response Type: ${response.data.runtimeType}');
    print('Price Response for coin $coinId: ${response.data}');

    if (response.data is List) {
      final priceList = response.data as List;
      
      if (priceList.isEmpty) {
        print('Warning: Empty price list for coin $coinId');
        return 0.0;
      }
      
      final lastPrice = priceList.last;
      final price = (lastPrice as num).toDouble();
      
      print('✅ Extracted price for coin $coinId: $price');
      return price;
    }

    print('❌ ERROR: Unexpected response format for coin $coinId');
    return 0.0;
  } on DioException catch (e) {
    print('=== Get Price Error for coin $coinId ===');
    print('Status Code: ${e.response?.statusCode}');
    print('Error Response: ${e.response?.data}');
    
    return 0.0;
  } catch (e) {
    print('=== Unknown Error for coin $coinId ===');
    print('Error: $e');
    return 0.0;
  }
}

  @override
  Future<Map<String, double>> getCryptoPrices() async {
    try {
      final prices = <String, double>{};
      
      print('=== Loading All Crypto Prices ===');
      
      // Отримуємо ціни для всіх монет послідовно
      for (final coin in CryptoCoin.values) {
        try {
          final price = await getCoinPrice(coin.id);
          prices[coin.symbol] = price;
          print('${coin.symbol}: \$${price.toStringAsFixed(2)}');
        } catch (e) {
          print('Error fetching price for ${coin.symbol}: $e');
          prices[coin.symbol] = 0.0;
        }
      }
      
      print('=== All Prices Loaded ===');
      print(prices);
      
      return prices;
    } catch (e) {
      print('Error fetching crypto prices: $e');
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
        return (response.data['balance'] as num).toDouble();
      }
      
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }
  @override
  Future<Map<int, double>> getUserCryptoBalances(int userId) async {
    try {
      final token = await _getToken();
      
      print('=== Get User Crypto Balances ===');
      
      final response = await _dio.get(
        '/user/$userId',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      final balances = <int, double>{};
      
      final wallet = response.data['wallet'];
      if (wallet != null && wallet['amountOfCoins'] != null) {
        final coins = wallet['amountOfCoins'] as List;
        for (var coinData in coins) {
          final coinId = coinData['name'] as int;
          final amount = (coinData['amount'] as num).toDouble();
          balances[coinId] = amount;
          print('Coin $coinId balance: $amount');
        }
      }
      
      return balances;
    } catch (e) {
      print('Error getting crypto balances: $e');
      return {};
    }
  }
  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
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