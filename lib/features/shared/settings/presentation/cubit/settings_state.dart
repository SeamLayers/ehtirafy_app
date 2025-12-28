import 'package:equatable/equatable.dart';
import '../../domain/entities/contact_info.dart';
import '../../domain/entities/static_page.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object> get props => [message];
}

class PrivacyPolicyLoaded extends SettingsState {
  final StaticPage data;

  const PrivacyPolicyLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class TermsConditionsLoaded extends SettingsState {
  final StaticPage data;

  const TermsConditionsLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class ContactUsLoaded extends SettingsState {
  final ContactInfo data;

  const ContactUsLoaded(this.data);

  @override
  List<Object> get props => [data];
}
