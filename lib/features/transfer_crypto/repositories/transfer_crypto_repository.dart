import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../buy_crypto/models/crypto_coin.dart';

abstract class TransferCryptoRepositoryInterface {
  Future<TransferCryptoResponse> transferCrypto({
    required int userId,
    required int coinForConvert,
    required int convertToCoin,
    required double amount,
  });
  
  Future<Map<String, double>> getCryptoPrices();
  Future<double> getCoinPrice(int coinId);
  Future<double> getUserBalance(int userId);
  Future<Map<int, double>> getUserCryptoBalances(int userId);
  Future<int?> getSavedUserId();
}

class TransferCryptoResponse {
  final bool success;
  final String? message;
  final double? newBalance;
  final Map<int, double>? cryptoBalances;

  TransferCryptoResponse({
    required this.success,
    this.message,
    this.newBalance,
    this.cryptoBalances,
  });

  factory TransferCryptoResponse.fromJson(Map<String, dynamic> json) {
    return TransferCryptoResponse(
      success: json['success'] ?? true,
      message: json['message'],
      newBalance: json['newBalance']?.toDouble(),
    );
  }
}

class TransferCryptoRepository implements TransferCryptoRepositoryInterface {
  final Dio _dio;

  TransferCryptoRepository({Dio? dio})
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
  Future<TransferCryptoResponse> transferCrypto({
    required int userId,
    required int coinForConvert,
    required int convertToCoin,
    required double amount,
  }) async {
    try {
      final token = await _getToken();
      final response = await _dio.post(
        '/user/$userId/wallet/convert',
        queryParameters: {
          'id': userId,
          'coinForConvert': coinForConvert,
          'convertToCoin': convertToCoin,
          'amount': amount,
        },
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      final wallet = response.data['wallet'];
      if (wallet != null && wallet['amountOfCoins'] != null) {
        final coins = wallet['amountOfCoins'] as List;
        print('Coins in wallet after transfer:');
        for (var coinData in coins) {
          print('  - Coin ${coinData['name']}: amount=${coinData['amount']} (price: \$${coinData['price']})');
        }
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newBalance = response.data['balance']?.toDouble();
        final cryptoBalances = <int, double>{};
        if (wallet != null && wallet['amountOfCoins'] != null) {
          final coins = wallet['amountOfCoins'] as List;
          for (var coinData in coins) {
            final coinId = coinData['name'] as int;
            final coinAmount = (coinData['amount'] as num).toDouble();
            cryptoBalances[coinId] = coinAmount;
          }
        }
        
        return TransferCryptoResponse(
          success: true,
          message: 'Transfer successful',
          newBalance: newBalance,
          cryptoBalances: cryptoBalances,
        );
      }

      return TransferCryptoResponse(
        success: false,
        message: 'Transfer failed',
      );
    } on DioException catch (e) {
      throw Exception(_handleError(e));
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

    if (response.data is List) {
      final priceList = response.data as List;
      
      if (priceList.isEmpty) {
        return 0.0;
      }
      
      final lastPrice = priceList.last;
      final price = (lastPrice as num).toDouble();
      return price;
    }
    return 0.0;
  } on DioException catch (e) {
    return 0.0;
  } catch (e) {
    return 0.0;
  }
}

  @override
  Future<Map<String, double>> getCryptoPrices() async {
    try {
    final prices = <String, double>{};
    
    
    for (final coin in CryptoCoin.values) {
      try {
        final price = await getCoinPrice(coin.id);
        prices[coin.symbol] = price;
      } catch (e) {
        print('Error fetching price for ${coin.symbol}: $e');
        prices[coin.symbol] = 0.0;
      }
    }

    
    return prices;
  } catch (e) {
    print('Error fetching crypto prices for sell: $e');
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

  @override
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