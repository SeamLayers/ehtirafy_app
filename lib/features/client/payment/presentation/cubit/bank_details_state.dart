import 'package:equatable/equatable.dart';
import '../../domain/entities/bank_account_entity.dart';

abstract class BankDetailsState extends Equatable {
  const BankDetailsState();

  @override
  List<Object?> get props => [];
}

class BankDetailsInitial extends BankDetailsState {
  const BankDetailsInitial();
}

class BankDetailsLoading extends BankDetailsState {
  const BankDetailsLoading();
}

class BankDetailsLoaded extends BankDetailsState {
  final BankAccountEntity bankAccount;

  const BankDetailsLoaded(this.bankAccount);

  @override
  List<Object?> get props => [bankAccount];
}

class BankDetailsError extends BankDetailsState {
  final String message;

  const BankDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
