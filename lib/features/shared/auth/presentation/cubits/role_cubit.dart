import 'package:bloc/bloc.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/usecases/role_usecases.dart';

abstract class RoleState { const RoleState(); }
class RoleInitial extends RoleState {}
class RoleLoading extends RoleState {}
class RoleLoaded extends RoleState { 
  final UserRole role;
  const RoleLoaded(this.role);
}
class RoleSwitching extends RoleState { 
  final UserRole fromRole;
  final UserRole toRole;
  const RoleSwitching(this.fromRole, this.toRole);
}
class RoleError extends RoleState { 
  final String failureKey; 
  const RoleError(this.failureKey); 
}
class RoleSaved extends RoleState { 
  final UserRole role; 
  const RoleSaved(this.role); 
}

class RoleCubit extends Cubit<RoleState> {
  final GetRoleUseCase _getRole;
  final SetRoleUseCase _setRole;
  UserRole _selected = UserRole.client;

  RoleCubit(this._getRole, this._setRole) : super(RoleInitial()) {
    load();
  }

  void load() async {
    emit(RoleLoading());
    final result = await _getRole.call();
    result.fold(
      (f) => emit(RoleError(f)),
      (role) {
        _selected = role;
        emit(RoleLoaded(role));
      },
    );
  }

  void select(UserRole role) {
    _selected = role;
    emit(RoleLoaded(role));
  }

  Future<void> save() async {
    emit(RoleLoaded(_selected));
    final result = await _setRole.call(_selected);
    result.fold(
      (f) => emit(RoleError(f)),
      (role) {
        _selected = role;
        emit(RoleLoaded(role));
      },
    );
  }

  /// Switch to a different role and ensure proper navigation
  Future<void> switchRole(UserRole newRole) async {
    final currentRole = _selected;
    
    // Don't switch if already on the same role
    if (currentRole == newRole) return;
    
    emit(RoleSwitching(currentRole, newRole));
    
    final result = await _setRole.call(newRole);
    result.fold(
      (f) {
        emit(RoleError(f));
        // Revert to loaded state with current role
        emit(RoleLoaded(currentRole));
      },
      (role) {
        _selected = newRole;
        emit(RoleLoaded(newRole));
      },
    );
  }

  UserRole get selected => _selected;
}

