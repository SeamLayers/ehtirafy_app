import 'package:ehtirafy_app/features/shared/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ehtirafy_app/features/shared/auth/data/datasources/user_local_data_source.dart';
import 'package:ehtirafy_app/features/shared/auth/data/repositories/auth_repository_impl.dart';
import 'package:ehtirafy_app/features/shared/auth/data/repositories/role_repository_impl.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/repositories/auth_repository.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/repositories/role_repository.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/login_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/role_usecases.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/send_otp_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/usecases/signup_usecase.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/forgot_password_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/login_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/otp_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/role_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/signup_cubit.dart';
import 'package:ehtirafy_app/features/shared/splash/presentation/cubits/splash_cubit.dart';
import 'package:get_it/get_it.dart';

extension AuthLocator on GetIt {
  void registerAuthDependencies() {
    registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(this()));
    registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(this(), this()));
    registerLazySingleton<RoleRepository>(() => RoleRepositoryImpl());

    registerFactory<LoginUseCase>(() => LoginUseCase(this<AuthRepository>()));
    registerLazySingleton<SignupUseCase>(() => SignupUseCase(this<AuthRepository>()));
    registerFactory<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(this<AuthRepository>()));
    registerFactory<SendOtpUseCase>(() => SendOtpUseCase(this<AuthRepository>()));
    registerFactory<GetRoleUseCase>(() => GetRoleUseCase(this()));
    registerFactory<SetRoleUseCase>(() => SetRoleUseCase(this()));

    registerFactory<LoginCubit>(() => LoginCubit(this<LoginUseCase>()));
    registerFactory<SignupCubit>(() => SignupCubit(this<SignupUseCase>(), this<SendOtpUseCase>()));
    registerFactory<ForgotPasswordCubit>(() => ForgotPasswordCubit(this<ForgotPasswordUseCase>()));
    registerFactory<OtpCubit>(() => OtpCubit());
    registerLazySingleton<RoleCubit>(() => RoleCubit(this<GetRoleUseCase>(), this<SetRoleUseCase>()));
    registerLazySingleton<UserLocalDataSource>(
      () => UserLocalDataSourceImpl(sharedPreferences: this()),
    );

    registerFactory(
      () => SplashCubit(
        userLocalDataSource: this<UserLocalDataSource>(),
        getRoleUseCase: this<GetRoleUseCase>(),
      ),
    );
  }
}
