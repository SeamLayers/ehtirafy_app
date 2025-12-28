import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/di/service_locator.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SettingsCubit>()..getContactUs(),
      child: Scaffold(
        appBar: AppBar(title: Text('settings.help_support'.tr())),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SettingsError) {
              return Center(child: Text(state.message));
            } else if (state is ContactUsLoaded) {
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.data.email != null)
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(state.data.email!),
                      ),
                    if (state.data.phone != null)
                      ListTile(
                        leading: const Icon(Icons.phone),
                        title: Text(state.data.phone!),
                      ),
                    if (state.data.whatsapp != null)
                      ListTile(
                        leading: const Icon(
                          Icons.perm_phone_msg,
                        ), // Whatsapp icon equivalent
                        title: Text(state.data.whatsapp!),
                      ),
                    if (state.data.address != null)
                      ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(state.data.address!),
                      ),
                  ],
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
