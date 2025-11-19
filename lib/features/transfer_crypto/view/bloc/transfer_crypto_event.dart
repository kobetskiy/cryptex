import 'package:equatable/equatable.dart';
import '../../../buy_crypto/models/crypto_coin.dart';

abstract class TransferCryptoEvent extends Equatable {
  const TransferCryptoEvent();

  @override
  List<Object?> get props => [];
}

class LoadCryptoPrices extends TransferCryptoEvent {
  const LoadCryptoPrices();
}

class LoadUserBalance extends TransferCryptoEvent {
  final int userId;

  const LoadUserBalance(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadUserCryptoBalances extends TransferCryptoEvent {
  final int userId;

  const LoadUserCryptoBalances(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SelectFromCoin extends TransferCryptoEvent {
  final CryptoCoin coin;

  const SelectFromCoin(this.coin);

  @override
  List<Object?> get props => [coin];
}

class SelectToCoin extends TransferCryptoEvent {
  final CryptoCoin coin;

  const SelectToCoin(this.coin);

  @override
  List<Object?> get props => [coin];
}

class UpdateAmount extends TransferCryptoEvent {
  final double amount;

  const UpdateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class SubmitTransferOrder extends TransferCryptoEvent {
  final int userId;

  const SubmitTransferOrder({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}