import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/switch_user_role_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../../auth/domain/usecases/logout_usecase.dart';
import '../../../auth/domain/usecases/delete_account_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final SwitchUserRoleUseCase switchUserRoleUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.switchUserRoleUseCase,
    required this.updateProfileUseCase,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
  }) : super(ProfileInitial());

  Future<void> loadUserProfile() async {
    emit(ProfileLoading());
    final result = await getUserProfileUseCase();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (userProfile) => emit(ProfileLoaded(userProfile)),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    emit(ProfileLoading());
    final result = await updateProfileUseCase(data);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (updatedProfile) => emit(ProfileUpdateSuccess(updatedProfile)),
    );
  }

  // Implemented logout logic
  Future<void> logout() async {
    emit(ProfileLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(ProfileLoggedOut()),
    );
  }

  Future<void> deleteAccount(String userId) async {
    emit(ProfileLoading());
    final result = await deleteAccountUseCase(userId);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(ProfileLoggedOut()), // We can emit ProfileLoggedOut so it navigates to login screen
    );
  }

  Future<void> toggleRole() async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(ProfileRoleSwitching(currentState.userProfile));

      final currentRole = currentState.userProfile.currentRole;
      final newRole = currentRole == UserRole.client
          ? UserRole.freelancer
          : UserRole.client;

      final result = await switchUserRoleUseCase(newRole);
      result.fold(
        (failure) => emit(ProfileError(failure.message)),
        (updatedProfile) => emit(ProfileLoaded(updatedProfile)),
      );
    }
  }
}
