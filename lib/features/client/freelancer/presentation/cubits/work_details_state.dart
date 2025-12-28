import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/work_details_entity.dart';

abstract class WorkDetailsState extends Equatable {
  const WorkDetailsState();

  @override
  List<Object?> get props => [];
}

class WorkDetailsInitial extends WorkDetailsState {}

class WorkDetailsLoading extends WorkDetailsState {}

class WorkDetailsLoaded extends WorkDetailsState {
  final WorkDetailsEntity workDetails;

  const WorkDetailsLoaded(this.workDetails);

  @override
  List<Object?> get props => [workDetails];
}

class WorkDetailsError extends WorkDetailsState {
  final String message;

  const WorkDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
