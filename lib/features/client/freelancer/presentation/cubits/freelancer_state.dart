import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';

abstract class FreelancerState extends Equatable {
  const FreelancerState();

  @override
  List<Object> get props => [];
}

class FreelancerInitial extends FreelancerState {}

class FreelancerLoading extends FreelancerState {}

class FreelancerLoaded extends FreelancerState {
  final FreelancerEntity freelancer;

  const FreelancerLoaded(this.freelancer);

  @override
  List<Object> get props => [freelancer];
}

class FreelancerError extends FreelancerState {
  final String message;

  const FreelancerError(this.message);

  @override
  List<Object> get props => [message];
}
