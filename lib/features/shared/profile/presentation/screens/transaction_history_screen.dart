import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_colors.dart';


class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profileTransactions.tr())),
      body: ListView.separated(
        padding: EdgeInsets.all(AppSpacing.lg),
        itemCount: 6,
        separatorBuilder: (_, __) => const Divider(color: AppColors.grey300),
        itemBuilder: (context, index) => ListTile(
          leading: const CircleAvatar(backgroundColor: AppColors.gold, child: Icon(Icons.payment, color: AppColors.dark)),
          title: Text('${AppStrings.transactionItemLabel.tr()} #$index'),
          subtitle: Text('500 ${AppStrings.bookingCurrency.tr()}'),
          trailing: Text(AppStrings.transactionStatusPaid.tr()),
        ),
      ),
    );
  }
}

