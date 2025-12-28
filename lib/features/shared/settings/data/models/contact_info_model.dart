import '../../domain/entities/contact_info.dart';

class ContactInfoModel extends ContactInfo {
  ContactInfoModel({super.email, super.phone, super.whatsapp, super.address});

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      email: json['email'],
      phone: json['phone'],
      whatsapp: json['whatsapp'],
      address: json['address'],
    );
  }
}
