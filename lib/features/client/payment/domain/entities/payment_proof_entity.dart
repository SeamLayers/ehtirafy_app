import 'package:equatable/equatable.dart';

class PaymentProofEntity extends Equatable {
  final String contractId;
  final String senderName;
  final DateTime transferDate;
  final String proofFilePath; // Local file path or URL after upload
  final String? transferReference; // Optional reference number
  final String? notes;

  const PaymentProofEntity({
    required this.contractId,
    required this.senderName,
    required this.transferDate,
    required this.proofFilePath,
    this.transferReference,
    this.notes,
  });

  @override
  List<Object?> get props => [
        contractId,
        senderName,
        transferDate,
        proofFilePath,
        transferReference,
        notes,
      ];
}
