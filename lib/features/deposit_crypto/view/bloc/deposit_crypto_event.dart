import 'package:equatable/equatable.dart';

abstract class DepositCryptoEvent extends Equatable {
  const DepositCryptoEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserCryptoBalance extends DepositCryptoEvent {
  final int userId;

  const LoadUserCryptoBalance(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateAmount extends DepositCryptoEvent {
  final double amount;

  const UpdateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class UpdateDepositAddress extends DepositCryptoEvent {
  final String depositAddress;

  const UpdateDepositAddress(this.depositAddress);

  @override
  List<Object?> get props => [depositAddress];
}

class SubmitDepositCrypto extends DepositCryptoEvent {
  final int userId;

  const SubmitDepositCrypto({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}