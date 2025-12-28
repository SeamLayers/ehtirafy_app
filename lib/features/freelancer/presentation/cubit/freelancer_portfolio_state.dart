import 'package:equatable/equatable.dart';
import '../../domain/entities/portfolio_item_entity.dart';

abstract class FreelancerPortfolioState extends Equatable {
  const FreelancerPortfolioState();

  @override
  List<Object?> get props => [];
}

class FreelancerPortfolioInitial extends FreelancerPortfolioState {}

class FreelancerPortfolioLoading extends FreelancerPortfolioState {}

class FreelancerPortfolioLoaded extends FreelancerPortfolioState {
  final List<PortfolioItemEntity> items;

  const FreelancerPortfolioLoaded({required this.items});

  @override
  List<Object?> get props => [items];

  FreelancerPortfolioLoaded copyWith({List<PortfolioItemEntity>? items}) {
    return FreelancerPortfolioLoaded(items: items ?? this.items);
  }
}

class FreelancerPortfolioError extends FreelancerPortfolioState {
  final String message;

  const FreelancerPortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}

class FreelancerPortfolioItemAdding extends FreelancerPortfolioState {}

class FreelancerPortfolioItemAdded extends FreelancerPortfolioState {
  final PortfolioItemEntity item;

  const FreelancerPortfolioItemAdded(this.item);

  @override
  List<Object?> get props => [item];
}
