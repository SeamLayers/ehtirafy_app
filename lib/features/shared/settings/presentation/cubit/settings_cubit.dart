import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_contact_us_usecase.dart';
import '../../domain/usecases/get_privacy_policy_usecase.dart';
import '../../domain/usecases/get_terms_conditions_usecase.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final GetPrivacyPolicyUseCase getPrivacyPolicyUseCase;
  final GetTermsConditionsUseCase getTermsConditionsUseCase;
  final GetContactUsUseCase getContactUsUseCase;

  SettingsCubit({
    required this.getPrivacyPolicyUseCase,
    required this.getTermsConditionsUseCase,
    required this.getContactUsUseCase,
  }) : super(SettingsInitial());

  Future<void> getPrivacyPolicy({String lang = 'ar'}) async {
    emit(SettingsLoading());
    final result = await getPrivacyPolicyUseCase(lang: lang);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (data) => emit(PrivacyPolicyLoaded(data)),
    );
  }

  Future<void> getTermsConditions({String lang = 'ar'}) async {
    emit(SettingsLoading());
    final result = await getTermsConditionsUseCase(lang: lang);
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (data) => emit(TermsConditionsLoaded(data)),
    );
  }

  Future<void> getContactUs() async {
    emit(SettingsLoading());
    final result = await getContactUsUseCase();
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (data) => emit(ContactUsLoaded(data)),
    );
  }
}
