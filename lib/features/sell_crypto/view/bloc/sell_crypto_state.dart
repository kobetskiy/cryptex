import 'package:equatable/equatable.dart';
import '../../../buy_crypto/models/crypto_coin.dart';

enum SellCryptoStatus { initial, loading, success, error }

class SellCryptoState extends Equatable {
  final SellCryptoStatus status;
  final CryptoCoin selectedCoin;
  final double amount;
  final Map<String, double> cryptoPrices;
  final Map<int, double> cryptoBalances;
  final String? errorMessage;
  final double? newBalance;
  final double userBalance;

  const SellCryptoState({
    this.status = SellCryptoStatus.initial,
    this.selectedCoin = CryptoCoin.bitcoin,
    this.amount = 0.0,
    this.cryptoPrices = const {},
    this.cryptoBalances = const {},
    this.errorMessage,
    this.newBalance,
    this.userBalance = 0.0,
  });

  // Отримуємо USD еквівалент продажу
  double get usdValue {
    final price = cryptoPrices[selectedCoin.symbol] ?? 0.0;
    if (price == 0) return 0.0;
    return amount * price;
  }

  // Отримуємо баланс вибраної монети
  double get selectedCoinBalance {
    return cryptoBalances[selectedCoin.id] ?? 0.0;
  }

  // Перевірка чи достатньо крипти для продажу
  bool get hasEnoughCrypto => amount <= selectedCoinBalance && amount > 0;

  SellCryptoState copyWith({
    SellCryptoStatus? status,
    CryptoCoin? selectedCoin,
    double? amount,
    Map<String, double>? cryptoPrices,
    Map<int, double>? cryptoBalances,
    String? errorMessage,
    double? newBalance,
    double? userBalance,
  }) {
    return SellCryptoState(
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
}