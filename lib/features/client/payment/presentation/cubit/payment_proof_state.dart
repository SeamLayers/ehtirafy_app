import 'package:equatable/equatable.dart';

abstract class PaymentProofState extends Equatable {
  const PaymentProofState();

  @override
  List<Object?> get props => [];
}

class PaymentProofInitial extends PaymentProofState {
  const PaymentProofInitial();
}

class PaymentProofLoading extends PaymentProofState {
  const PaymentProofLoading();
}

class PaymentProofSubmitted extends PaymentProofState {
  final String message;

  const PaymentProofSubmitted(this.message);

  @override
  List<Object?> get props => [message];
}

class PaymentProofError extends PaymentProofState {
  final String message;

  const PaymentProofError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State indicating file is being processed (uploaded locally or preparing for upload)
class PaymentProofFileSelected extends PaymentProofState {
  final String fileName;
  final String filePath;

  const PaymentProofFileSelected({
    required this.fileName,
    required this.filePath,
  });

  @override
  List<Object?> get props => [fileName, filePath];
}
