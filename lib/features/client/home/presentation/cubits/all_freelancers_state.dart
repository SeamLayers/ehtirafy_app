import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';

abstract class AllFreelancersState extends Equatable {
  const AllFreelancersState();

  @override
  List<Object?> get props => [];
}

class AllFreelancersInitial extends AllFreelancersState {}

class AllFreelancersLoading extends AllFreelancersState {}

class AllFreelancersLoaded extends AllFreelancersState {
  final List<PhotographerEntity> freelancers;

  const AllFreelancersLoaded(this.freelancers);

  @override
  List<Object?> get props => [freelancers];
}

class AllFreelancersError extends AllFreelancersState {
  final String message;

  const AllFreelancersError(this.message);

  @override
  List<Object?> get props => [message];
}
