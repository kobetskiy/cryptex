import 'package:equatable/equatable.dart';

enum DepositFundsStatus { initial, loading, success, error }

class DepositFundsState extends Equatable {
  final DepositFundsStatus status;
  final double amount;
  final String? errorMessage;
  final double? newBalance;
  final double userBalance;

  const DepositFundsState({
    this.status = DepositFundsStatus.initial,
    this.amount = 0.0,
    this.errorMessage,
    this.newBalance,
    this.userBalance = 0.0,
  });

  DepositFundsState copyWith({
    DepositFundsStatus? status,
    double? amount,
    String? errorMessage,
    double? newBalance,
    double? userBalance,
  }) {
    return DepositFundsState(
      status: status ?? this.status,
      amount: amount ?? this.amount,
      errorMessage: errorMessage,
      newBalance: newBalance ?? this.newBalance,
      userBalance: userBalance ?? this.userBalance,
    );
  }

  @override
  List<Object?> get props => [
        status,
        amount,
        errorMessage,
        newBalance,
        userBalance,
      ];
}