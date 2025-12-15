import 'package:equatable/equatable.dart';
import '../../../buy_crypto/models/crypto_coin.dart';

enum WithdrawCryptoStatus { initial, loading, success, error }

class WithdrawCryptoState extends Equatable {
  final WithdrawCryptoStatus status;
  final CryptoCoin selectedCoin;
  final double amount;
  final String externalAddress;
  final Map<String, double> cryptoPrices;
  final Map<int, double> cryptoBalances;
  final String? errorMessage;
  final double? newBalance;
  final double userBalance;

  const WithdrawCryptoState({
    this.status = WithdrawCryptoStatus.initial,
    this.selectedCoin = CryptoCoin.bitcoin,
    this.amount = 0.0,
    this.externalAddress = '',
    this.cryptoPrices = const {},
    this.cryptoBalances = const {},
    this.errorMessage,
    this.newBalance,
    this.userBalance = 0.0,
  });

  double get usdValue {
    final coinPrice = cryptoPrices[selectedCoin.symbol] ?? 0.0;
    return amount * coinPrice;
  }

  double get selectedCoinBalance {
    return cryptoBalances[selectedCoin.id] ?? 0.0;
  }

  bool get hasEnoughCrypto => amount <= selectedCoinBalance && amount > 0;

  bool get canWithdraw => 
      amount > 0 && 
      externalAddress.isNotEmpty && 
      hasEnoughCrypto;

  WithdrawCryptoState copyWith({
    WithdrawCryptoStatus? status,
    CryptoCoin? selectedCoin,
    double? amount,
    String? externalAddress,
    Map<String, double>? cryptoPrices,
    Map<int, double>? cryptoBalances,
    String? errorMessage,
    double? newBalance,
    double? userBalance,
  }) {
    return WithdrawCryptoState(
      status: status ?? this.status,
      selectedCoin: selectedCoin ?? this.selectedCoin,
      amount: amount ?? this.amount,
      externalAddress: externalAddress ?? this.externalAddress,
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
        selectedCoin,
        amount,
        externalAddress,
        cryptoPrices,
        cryptoBalances,
        errorMessage,
        newBalance,
        userBalance,
      ];
}