import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileEntity userProfile;

  const ProfileLoaded(this.userProfile);

  @override
  List<Object> get props => [userProfile];
}

class ProfileUpdateSuccess extends ProfileLoaded {
  const ProfileUpdateSuccess(super.userProfile);
}

class ProfileRoleSwitching extends ProfileState {
  final UserProfileEntity userProfile;

  const ProfileRoleSwitching(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class ProfileLoggedOut extends ProfileState {}
