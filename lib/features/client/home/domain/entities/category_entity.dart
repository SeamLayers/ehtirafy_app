import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;
  final bool isActive;
  final DateTime? createdAt;

  const CategoryEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.isActive = true,
    this.createdAt,
  });

  /// Returns the localized name based on locale code
  String getLocalizedName(String localeCode) {
    return localeCode == 'ar' ? nameAr : nameEn;
  }

  @override
  List<Object?> get props => [id, nameAr, nameEn, isActive, createdAt];
}
