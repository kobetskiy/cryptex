import 'package:equatable/equatable.dart';
import '../../../buy_crypto/models/crypto_coin.dart';

abstract class WithdrawCryptoEvent extends Equatable {
  const WithdrawCryptoEvent();

  @override
  List<Object?> get props => [];
}

class LoadCryptoPrices extends WithdrawCryptoEvent {
  const LoadCryptoPrices();
}

class LoadUserBalance extends WithdrawCryptoEvent {
  final int userId;

  const LoadUserBalance(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadUserCryptoBalances extends WithdrawCryptoEvent {
  final int userId;

  const LoadUserCryptoBalances(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SelectCoin extends WithdrawCryptoEvent {
  final CryptoCoin coin;

  const SelectCoin(this.coin);

  @override
  List<Object?> get props => [coin];
}

class UpdateAmount extends WithdrawCryptoEvent {
  final double amount;

  const UpdateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class UpdateExternalAddress extends WithdrawCryptoEvent {
  final String address;

  const UpdateExternalAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class SubmitWithdrawOrder extends WithdrawCryptoEvent {
  final int userId;

  const SubmitWithdrawOrder({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}