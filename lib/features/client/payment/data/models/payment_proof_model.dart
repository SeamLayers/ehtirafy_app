import 'package:ehtirafy_app/features/client/payment/domain/entities/payment_proof_entity.dart';

class PaymentProofModel extends PaymentProofEntity {
  const PaymentProofModel({
    required super.contractId,
    required super.senderName,
    required super.transferDate,
    required super.proofFilePath,
    super.transferReference,
    super.notes,
  });

  factory PaymentProofModel.fromJson(Map<String, dynamic> json) {
    return PaymentProofModel(
      contractId:
          (json['contract_id'] ?? json['contractId'])?.toString() ?? '',
      senderName:
          (json['sender_name'] ?? json['senderName'])?.toString() ?? '',
      transferDate:
          DateTime.tryParse(json['transfer_date']?.toString() ?? '') ??
              DateTime.now(),
      proofFilePath:
          (json['proof_file_path'] ?? json['proofFilePath'])?.toString() ?? '',
      transferReference:
          (json['transfer_reference'] ?? json['transferReference'])?.toString(),
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contract_id': contractId,
      'sender_name': senderName,
      'transfer_date': transferDate.toIso8601String(),
      'proof_file_path': proofFilePath,
      'transfer_reference': transferReference,
      'notes': notes,
    };
  }
}
