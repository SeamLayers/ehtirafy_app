import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../../domain/usecases/submit_payment_proof_usecase.dart';
import 'payment_proof_state.dart';

class PaymentProofCubit extends Cubit<PaymentProofState> {
  final SubmitPaymentProofUseCase submitPaymentProofUseCase;

  PaymentProofCubit(this.submitPaymentProofUseCase)
      : super(const PaymentProofInitial());

  /// Handle file selection (update UI to show selected file)
  void onFileSelected(String fileName, String filePath) {
    emit(PaymentProofFileSelected(
      fileName: fileName,
      filePath: filePath,
    ));
  }

  /// Handle file deselection (clear the selection)
  void onFileClear() {
    emit(const PaymentProofInitial());
  }

  /// Submit payment proof form
  Future<void> submitPaymentProof({
    required String contractId,
    required String senderName,
    required DateTime transferDate,
    required String proofFilePath,
    String? transferReference,
    String? notes,
  }) async {
    emit(const PaymentProofLoading());

    final result = await submitPaymentProofUseCase(
      SubmitPaymentProofParams(
        contractId: contractId,
        senderName: senderName,
        transferDate: transferDate,
        proofFilePath: proofFilePath,
        transferReference: transferReference,
        notes: notes,
      ),
    );

    result.fold(
      (failure) => emit(PaymentProofError(_mapFailureToMessage(failure))),
      (_) => emit(
        const PaymentProofSubmitted(
          'تم إرسال إثبات الدفع بنجاح. سيتم التحقق منه من قبل فريق الإدارة.',
        ),
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    }
    return 'حدث خطأ غير متوقع';
  }
}
