import 'package:equatable/equatable.dart';

abstract class WithdrawFundsEvent extends Equatable {
  const WithdrawFundsEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserBalance extends WithdrawFundsEvent {
  final int userId;

  const LoadUserBalance(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateAmount extends WithdrawFundsEvent {
  final double amount;

  const UpdateAmount(this.amount);

  @override
  List<Object?> get props => [amount];
}

class SubmitWithdrawOrder extends WithdrawFundsEvent {
  final int userId;

  const SubmitWithdrawOrder({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}