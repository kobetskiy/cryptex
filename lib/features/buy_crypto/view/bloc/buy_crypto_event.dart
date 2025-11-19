import 'package:equatable/equatable.dart';
import '../../models/crypto_coin.dart';

abstract class BuyCryptoEvent extends Equatable {
  const BuyCryptoEvent();

  @override
  List<Object?> get props => [];
}

class LoadCryptoPrices extends BuyCryptoEvent {
  const LoadCryptoPrices();
}

class SelectCoin extends BuyCryptoEvent {
  final CryptoCoin coin;

  const SelectCoin(this.coin);

  @override
  List<Object?> get props => [coin];
}

class UpdateAmount extends BuyCryptoEvent {
  final double amount;

  const UpdateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}
class LoadUserBalance extends BuyCryptoEvent {
  final int userId;

  const LoadUserBalance(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SubmitBuyOrder extends BuyCryptoEvent {
  final int userId;
  final String paymentMethod;

  const SubmitBuyOrder({
    required this.userId,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [userId, paymentMethod];
}