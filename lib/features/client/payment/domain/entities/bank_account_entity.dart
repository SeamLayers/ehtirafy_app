import 'package:equatable/equatable.dart';

class BankAccountEntity extends Equatable {
  final String accountName;
  final String iban;
  final String bankName;
  final String? accountNumber;
  final String? swiftCode;
  final String? branchCode;

  const BankAccountEntity({
    required this.accountName,
    required this.iban,
    required this.bankName,
    this.accountNumber,
    this.swiftCode,
    this.branchCode,
  });

  @override
  List<Object?> get props => [
        accountName,
        iban,
        bankName,
        accountNumber,
        swiftCode,
        branchCode,
      ];
}
