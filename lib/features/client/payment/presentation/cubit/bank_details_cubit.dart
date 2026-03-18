import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/core/domain/usecase.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../../domain/usecases/get_bank_account_details_usecase.dart';
import 'bank_details_state.dart';

class BankDetailsCubit extends Cubit<BankDetailsState> {
  final GetBankAccountDetailsUseCase getBankAccountDetailsUseCase;

  BankDetailsCubit(this.getBankAccountDetailsUseCase)
      : super(const BankDetailsInitial());

  Future<void> fetchBankDetails() async {
    emit(const BankDetailsLoading());
    final result = await getBankAccountDetailsUseCase(const NoParams());
    result.fold(
      (failure) => emit(BankDetailsError(_mapFailureToMessage(failure))),
      (bankAccount) => emit(BankDetailsLoaded(bankAccount)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'حدث خطأ غير متوقع';
  }
}
