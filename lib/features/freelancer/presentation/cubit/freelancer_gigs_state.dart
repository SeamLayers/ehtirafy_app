import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import '../../domain/entities/gig_entity.dart';

abstract class FreelancerGigsState extends Equatable {
  const FreelancerGigsState();

  @override
  List<Object?> get props => [];
}

class FreelancerGigsInitial extends FreelancerGigsState {}

class FreelancerGigsLoading extends FreelancerGigsState {}

class FreelancerGigsLoaded extends FreelancerGigsState {
  final List<GigEntity> gigs;
  final List<CategoryEntity> categories;

  const FreelancerGigsLoaded({required this.gigs, required this.categories});

  @override
  List<Object?> get props => [gigs, categories];

  FreelancerGigsLoaded copyWith({
    List<GigEntity>? gigs,
    List<CategoryEntity>? categories,
  }) {
    return FreelancerGigsLoaded(
      gigs: gigs ?? this.gigs,
      categories: categories ?? this.categories,
    );
  }
}

class FreelancerGigsError extends FreelancerGigsState {
  final String message;

  const FreelancerGigsError(this.message);

  @override
  List<Object?> get props => [message];
}

class FreelancerGigAdding extends FreelancerGigsState {}

class FreelancerGigAdded extends FreelancerGigsState {
  final GigEntity gig;

  const FreelancerGigAdded(this.gig);

  @override
  List<Object?> get props => [gig];
}

class FreelancerGigAddError extends FreelancerGigsState {
  final String message;

  const FreelancerGigAddError(this.message);

  @override
  List<Object?> get props => [message];
}

class FreelancerGigUpdating extends FreelancerGigsState {}

class FreelancerGigUpdated extends FreelancerGigsState {
  final GigEntity gig;

  const FreelancerGigUpdated(this.gig);

  @override
  List<Object?> get props => [gig];
}

class FreelancerGigUpdateError extends FreelancerGigsState {
  final String message;

  const FreelancerGigUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
