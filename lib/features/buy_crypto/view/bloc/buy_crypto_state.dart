import 'package:equatable/equatable.dart';
import '../../models/crypto_coin.dart';

enum BuyCryptoStatus { initial, loading, success, error }

class BuyCryptoState extends Equatable {
  final BuyCryptoStatus status;
  final CryptoCoin selectedCoin;
  final double amount;
  final Map<String, double> cryptoPrices;
  final Map<int, double> cryptoBalances;
  final String? errorMessage;
  final double? newBalance;
  final double userBalance;

  const BuyCryptoState({
    this.status = BuyCryptoStatus.initial,
    this.selectedCoin = CryptoCoin.bitcoin,
    this.amount = 0.0,
    this.cryptoPrices = const {},
    this.cryptoBalances = const {},
    this.errorMessage,
    this.newBalance,
    this.userBalance = 0.0,
  });

  double get cost {
    final price = cryptoPrices[selectedCoin.symbol] ?? 0.0;
    if (price == 0) return 0.0;
    return amount / price;
  }
  bool get hasEnoughBalance => amount <= userBalance && amount > 0;

  @override
  List<Object?> get props => [
        status,
        selectedCoin,
        amount,
        cryptoPrices,
        cryptoBalances,
        errorMessage,
        newBalance,
        userBalance,
      ];

  BuyCryptoState copyWith({
    BuyCryptoStatus? status,
    CryptoCoin? selectedCoin,
    double? amount,
    Map<String, double>? cryptoPrices,
    Map<int, double>? cryptoBalances,
    String? errorMessage,
    double? newBalance,
    double? userBalance,
  }) {
    return BuyCryptoState(
      status: status ?? this.status,
      selectedCoin: selectedCoin ?? this.selectedCoin,
      amount: amount ?? this.amount,
      cryptoPrices: cryptoPrices ?? this.cryptoPrices,
      cryptoBalances: cryptoBalances ?? this.cryptoBalances,
      errorMessage: errorMessage,
      newBalance: newBalance ?? this.newBalance,
      userBalance: userBalance ?? this.userBalance,
    );
  }
}