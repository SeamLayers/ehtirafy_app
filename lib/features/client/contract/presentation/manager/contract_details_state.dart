import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';

abstract class ContractDetailsState extends Equatable {
  const ContractDetailsState();

  @override
  List<Object> get props => [];
}

class ContractDetailsInitial extends ContractDetailsState {}

class ContractDetailsLoading extends ContractDetailsState {}

class ContractDetailsSuccess extends ContractDetailsState {
  final ContractDetailsEntity contract;

  const ContractDetailsSuccess(this.contract);

  @override
  List<Object> get props => [contract];
}

class ContractDetailsError extends ContractDetailsState {
  final String message;

  const ContractDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
