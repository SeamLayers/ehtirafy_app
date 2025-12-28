import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/entities/review_entity.dart';

abstract class ReviewsState extends Equatable {
  const ReviewsState();

  @override
  List<Object> get props => [];
}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final List<ReviewEntity> reviews;

  const ReviewsLoaded(this.reviews);

  @override
  List<Object> get props => [reviews];
}

class ReviewsActionSuccess extends ReviewsState {
  final String message;

  const ReviewsActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ReviewsError extends ReviewsState {
  final String message;

  const ReviewsError(this.message);

  @override
  List<Object> get props => [message];
}
