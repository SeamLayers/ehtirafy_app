import 'package:bloc/bloc.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/usecases/role_usecases.dart';

abstract class RoleState { const RoleState(); }
class RoleInitial extends RoleState {}
class RoleLoading extends RoleState {}
class RoleLoaded extends RoleState { final UserRole role; const RoleLoaded(this.role); }
class RoleSaving extends RoleState { final UserRole role; const RoleSaving(this.role); }
class RoleError extends RoleState { final String failureKey; const RoleError(this.failureKey); }
class RoleSaved extends RoleState { final UserRole role; const RoleSaved(this.role); }

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
    emit(RoleSaving(_selected));
    final result = await _setRole.call(_selected);
    result.fold(
      (f) => emit(RoleError(f)),
      (role) => emit(RoleSaved(role)),
    );
  }

  UserRole get selected => _selected;
}

