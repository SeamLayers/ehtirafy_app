import 'package:ehtirafy_app/features/client/payment/domain/entities/bank_account_entity.dart';

class BankAccountModel extends BankAccountEntity {
  const BankAccountModel({
    required super.accountName,
    required super.iban,
    required super.bankName,
    super.accountNumber,
    super.swiftCode,
    super.branchCode,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      accountName: json['account_name'] ?? json['accountName'] ?? '',
      iban: json['iban'] ?? '',
      bankName: json['bank_name'] ?? json['bankName'] ?? '',
      accountNumber: json['account_number'] ?? json['accountNumber'],
      swiftCode: json['swift_code'] ?? json['swiftCode'],
      branchCode: json['branch_code'] ?? json['branchCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_name': accountName,
      'iban': iban,
      'bank_name': bankName,
      'account_number': accountNumber,
      'swift_code': swiftCode,
      'branch_code': branchCode,
    };
  }
}
