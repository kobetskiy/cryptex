import 'package:equatable/equatable.dart';
import '../../../buy_crypto/models/crypto_coin.dart';

enum TransferCryptoStatus { initial, loading, success, error }

class TransferCryptoState extends Equatable {
  final TransferCryptoStatus status;
  final CryptoCoin fromCoin;
  final CryptoCoin toCoin;
  final double amount;
  final Map<String, double> cryptoPrices;
  final Map<int, double> cryptoBalances;
  final String? errorMessage;
  final double? newBalance;
  final double userBalance;

  const TransferCryptoState({
    this.status = TransferCryptoStatus.initial,
    this.fromCoin = CryptoCoin.bitcoin,
    this.toCoin = CryptoCoin.ethereum,
    this.amount = 0.0,
    this.cryptoPrices = const {},
    this.cryptoBalances = const {},
    this.errorMessage,
    this.newBalance,
    this.userBalance = 0.0,
  });

  double get convertedAmount {
    final fromPrice = cryptoPrices[fromCoin.symbol] ?? 0.0;
    final toPrice = cryptoPrices[toCoin.symbol] ?? 0.0;
    
    if (fromPrice == 0 || toPrice == 0) return 0.0;
    
    return (amount * fromPrice) / toPrice;
  }

  double get usdValue {
    final fromPrice = cryptoPrices[fromCoin.symbol] ?? 0.0;
    return amount * fromPrice;
  }

  double get fromCoinBalance {
    return cryptoBalances[fromCoin.id] ?? 0.0;
  }

  double get toCoinBalance {
    return cryptoBalances[toCoin.id] ?? 0.0;
  }

  bool get hasEnoughCrypto => amount <= fromCoinBalance && amount > 0;

  bool get coinsAreDifferent => fromCoin != toCoin;

  TransferCryptoState copyWith({
    TransferCryptoStatus? status,
    CryptoCoin? fromCoin,
    CryptoCoin? toCoin,
    double? amount,
    Map<String, double>? cryptoPrices,
    Map<int, double>? cryptoBalances,
    String? errorMessage,
    double? newBalance,
    double? userBalance,
  }) {
    return TransferCryptoState(
      status: status ?? this.status,
      fromCoin: fromCoin ?? this.fromCoin,
      toCoin: toCoin ?? this.toCoin,
      amount: amount ?? this.amount,
      cryptoPrices: cryptoPrices ?? this.cryptoPrices,
      cryptoBalances: cryptoBalances ?? this.cryptoBalances,
      errorMessage: errorMessage,
      newBalance: newBalance ?? this.newBalance,
      userBalance: userBalance ?? this.userBalance,
    );
  }

  @override
  List<Object?> get props => [
        status,
        fromCoin,
        toCoin,
        amount,
        cryptoPrices,
        cryptoBalances,
        errorMessage,
        newBalance,
        userBalance,
      ];
}