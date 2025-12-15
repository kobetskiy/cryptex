import 'package:equatable/equatable.dart';

enum DepositCryptoStatus { initial, loading, success, error }

class DepositCryptoState extends Equatable {
  final DepositCryptoStatus status;
  final double amount;
  final String depositAddress;
  final String? errorMessage;
  final double? newBalance;
  final double userCryptoBalance;

  const DepositCryptoState({
    this.status = DepositCryptoStatus.initial,
    this.amount = 0.0,
    this.depositAddress = '',
    this.errorMessage,
    this.newBalance,
    this.userCryptoBalance = 0.0,
  });

  DepositCryptoState copyWith({
    DepositCryptoStatus? status,
    double? amount,
    String? depositAddress,
    String? errorMessage,
    double? newBalance,
    double? userCryptoBalance,
  }) {
    return DepositCryptoState(
      status: status ?? this.status,
      amount: amount ?? this.amount,
      depositAddress: depositAddress ?? this.depositAddress,
      errorMessage: errorMessage,
      newBalance: newBalance ?? this.newBalance,
      userCryptoBalance: userCryptoBalance ?? this.userCryptoBalance,
    );
  }

  @override
  List<Object?> get props => [
        status,
        amount,
        depositAddress,
        errorMessage,
        newBalance,
        userCryptoBalance,
      ];
}