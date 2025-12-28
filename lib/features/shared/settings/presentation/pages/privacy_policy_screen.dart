import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/di/service_locator.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsCubit>()..getPrivacyPolicy(),
      child: Scaffold(
        appBar: AppBar(title: Text('settings.privacy_policy'.tr())),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsError) {
              return Center(child: Text(state.message));
            } else if (state is PrivacyPolicyLoaded) {
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  state.data.content,
                  style: TextStyle(fontSize: 14.sp),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
