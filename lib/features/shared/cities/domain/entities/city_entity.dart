import 'package:equatable/equatable.dart';

/// A Saudi city. The backend identifies a city by its name only (there is no
/// numeric id), so [nameEn] is used as the canonical key for equality and
/// client-side ad filtering, while [nameAr] is shown in the Arabic UI.
class CityEntity extends Equatable {
  final String nameAr;
  final String nameEn;

  const CityEntity({required this.nameAr, required this.nameEn});

  /// Localized display name based on the locale code ('ar' → Arabic).
  String getLocalizedName(String localeCode) {
    if (localeCode == 'ar') {
      return nameAr.isNotEmpty ? nameAr : nameEn;
    }
    return nameEn.isNotEmpty ? nameEn : nameAr;
  }

  @override
  List<Object?> get props => [nameAr, nameEn];
}
