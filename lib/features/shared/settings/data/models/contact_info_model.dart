import '../../domain/entities/contact_info.dart';

class ContactInfoModel extends ContactInfo {
  ContactInfoModel({super.email, super.phone, super.whatsapp, super.address});

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      whatsapp: json['whatsapp']?.toString(),
      address: json['address'] is String?
          ? json['address'] as String?
          : json['address']?.toString(),
    );
  }
}
