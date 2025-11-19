import 'package:equatable/equatable.dart';
import '../../../buy_crypto/models/crypto_coin.dart';

abstract class SellCryptoEvent extends Equatable {
  const SellCryptoEvent();

  @override
  List<Object?> get props => [];
}

class LoadCryptoPrices extends SellCryptoEvent {
  const LoadCryptoPrices();
}

class LoadUserBalance extends SellCryptoEvent {
  final int userId;

  const LoadUserBalance(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadUserCryptoBalances extends SellCryptoEvent {
  final int userId;

  const LoadUserCryptoBalances(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SelectCoin extends SellCryptoEvent {
  final CryptoCoin coin;

  const SelectCoin(this.coin);

  @override
  List<Object?> get props => [coin];
}

class UpdateAmount extends SellCryptoEvent {
  final double amount;

  const UpdateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class SubmitSellOrder extends SellCryptoEvent {
  final int userId;

  const SubmitSellOrder({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}