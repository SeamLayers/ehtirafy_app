import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/advertisement_details_entity.dart';

abstract class AdvertisementDetailsState extends Equatable {
  const AdvertisementDetailsState();

  @override
  List<Object?> get props => [];
}

class AdvertisementDetailsInitial extends AdvertisementDetailsState {}

class AdvertisementDetailsLoading extends AdvertisementDetailsState {}

class AdvertisementDetailsLoaded extends AdvertisementDetailsState {
  final AdvertisementDetailsEntity advertisementDetails;

  const AdvertisementDetailsLoaded(this.advertisementDetails);

  @override
  List<Object?> get props => [advertisementDetails];
}

class AdvertisementDetailsError extends AdvertisementDetailsState {
  final String message;

  const AdvertisementDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
