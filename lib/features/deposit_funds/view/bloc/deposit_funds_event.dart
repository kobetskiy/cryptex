import 'package:equatable/equatable.dart';

abstract class DepositFundsEvent extends Equatable {
  const DepositFundsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserBalance extends DepositFundsEvent {
  final int userId;

  const LoadUserBalance(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateAmount extends DepositFundsEvent {
  final double amount;

  const UpdateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class SubmitDepositOrder extends DepositFundsEvent {
  final int userId;

  const SubmitDepositOrder({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}