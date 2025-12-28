import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/user_role_repository.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../datasources/user_role_local_data_source.dart';

/// Implementation of UserRoleRepository
class UserRoleRepositoryImpl implements UserRoleRepository {
  final UserRoleLocalDataSource localDataSource;
  final StreamController<UserRoleEntity> _roleController;

  UserRoleRepositoryImpl({required this.localDataSource})
    : _roleController = StreamController<UserRoleEntity>.broadcast();

  @override
  Future<Either<Failure, UserRoleEntity>> getCurrentRole() async {
    try {
      final cachedRole = await localDataSource.getCachedRole();

      if (cachedRole == null || cachedRole == UserRole.guest) {
        return const Right(UserRoleEntity.guest());
      }

      final roleEntity = UserRoleEntity(
        role: cachedRole,
        isAuthenticated: true,
      );

      return Right(roleEntity);
    } catch (e) {
      // CacheFailure now uses localized message from failures.cache
      return const Left(CacheFailure('failures.cache'));
    }
  }

  @override
  Future<Either<Failure, UserRoleEntity>> switchRole(UserRole newRole) async {
    try {
      await localDataSource.cacheRole(newRole);

      final roleEntity = UserRoleEntity(
        role: newRole,
        isAuthenticated: newRole != UserRole.guest,
      );

      // Notify listeners about the role change
      _roleController.add(roleEntity);

      return Right(roleEntity);
    } catch (e) {
      // CacheFailure now uses localized message from failures.cache
      return const Left(CacheFailure('failures.cache'));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveRole(UserRole role) async {
    try {
      await localDataSource.cacheRole(role);
      return const Right(unit);
    } catch (e) {
      // CacheFailure now uses localized message from failures.cache
      return const Left(CacheFailure('failures.cache'));
    }
  }

  @override
  Stream<UserRoleEntity> watchRoleChanges() {
    return _roleController.stream;
  }

  @override
  Future<Either<Failure, Unit>> clearRole() async {
    try {
      await localDataSource.clearCachedRole();
      _roleController.add(const UserRoleEntity.guest());
      return const Right(unit);
    } catch (e) {
      // CacheFailure now uses localized message from failures.cache
      return const Left(CacheFailure('failures.cache'));
    }
  }

  void dispose() {
    _roleController.close();
  }
}
