import 'package:ehtirafy_app/features/client/payment/data/datasources/payment_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/payment/data/repositories/payment_repository_impl.dart';
import 'package:ehtirafy_app/features/client/payment/domain/repositories/payment_repository.dart';
import 'package:ehtirafy_app/features/client/payment/domain/usecases/get_bank_account_details_usecase.dart';
import 'package:ehtirafy_app/features/client/payment/domain/usecases/submit_payment_proof_usecase.dart';
import 'package:ehtirafy_app/features/client/payment/presentation/cubit/bank_details_cubit.dart';
import 'package:ehtirafy_app/features/client/payment/presentation/cubit/payment_proof_cubit.dart';
import 'package:get_it/get_it.dart';

extension ClientPaymentLocator on GetIt {
  void registerClientPaymentDependencies() {
    registerFactory(() => BankDetailsCubit(this()));
    registerFactory(() => PaymentProofCubit(this()));
    registerLazySingleton(() => GetBankAccountDetailsUseCase(this()));
    registerLazySingleton(() => SubmitPaymentProofUseCase(this()));
    registerLazySingleton<PaymentRepository>(() => PaymentRepositoryImpl(this()));
    registerLazySingleton<PaymentRemoteDataSource>(
      () => PaymentRemoteDataSourceImpl(this()),
    );
  }
}
