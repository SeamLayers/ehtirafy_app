import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';

import 'dart:convert';

class ContractDetailsModel extends ContractDetailsEntity {
  const ContractDetailsModel({
    required super.id,
    required super.status,
    required super.serviceTitle,
    required super.serviceCategory,
    required super.description,
    required super.location,
    required super.date,
    required super.budget,
    required super.isPaymentDeposited,
    required super.photographerName,
    required super.photographerImage,
    super.approvedAt,
    super.contractStatus,
    super.publisherId,
    super.publisherPhone,
    super.publisherEmail,
    super.customerId,
    super.customerName,
    super.customerImage,
    super.customerPhone,
    super.customerEmail,
    super.notes,
    super.daysAvailability,
    super.advertisementId,
  });

  factory ContractDetailsModel.fromJson(Map<String, dynamic> json) {
    final advertisement = json['advertisement'] is Map
        ? Map<String, dynamic>.from(json['advertisement'] as Map)
        : <String, dynamic>{};
    final rawTitle = advertisement['title'];
    final rawDescription = advertisement['description'];
    return ContractDetailsModel(
      id: json['id']?.toString() ?? '',
      status: deriveStatus(json),
      serviceTitle: _localized(rawTitle),
      serviceCategory: advertisement['category_id']?.toString() ?? '',
      description: _localized(rawDescription),
      // Real data: derive country from customer (fallback publisher) country_code.
      location: _countryFromCode(
        json['customer']?['country_code']?.toString() ??
            json['publisher']?['country_code']?.toString(),
      ),
      date: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      budget:
          double.tryParse(json['requested_amount']?.toString() ?? '0') ?? 0.0,
        isPaymentDeposited:
          json['contract_status']?.toString().toLowerCase() == 'inprocess' ||
          json['contract_status']?.toString().toLowerCase() == 'inprogress' ||
          json['contract_status']?.toString().toLowerCase() == 'completed',
      photographerName: json['publisher']?['name']?.toString() ?? '',
      // Publisher has no avatar key; use the advertisement cover image instead.
      // Will be '' until backend adds images to the nested advertisement (branded placeholder shown).
      photographerImage:
          (advertisement['images'] is List &&
                  (advertisement['images'] as List).isNotEmpty)
              ? (advertisement['images'] as List).first?.toString() ?? ''
              : '',
      approvedAt: json['approval_at'] != null
          ? DateTime.tryParse(json['approval_at'].toString())
          : null,
      contractStatus: json['contract_status']?.toString(),
      publisherId: json['publisher']?['id']?.toString() ?? '',
      publisherPhone: json['publisher']?['phone']?.toString() ?? '',
      publisherEmail: json['publisher']?['email']?.toString() ?? '',
      customerId: json['customer']?['id']?.toString() ?? '',
      customerName: json['customer']?['name']?.toString() ?? '',
      customerImage: json['customer']?['image']?.toString() ?? '',
      customerPhone: json['customer']?['phone']?.toString() ?? '',
      customerEmail: json['customer']?['email']?.toString() ?? '',
      notes: _parseNotes(json),
      daysAvailability: _parseDaysAvailability(json),
      advertisementId: json['advertisement_id']?.toString() ?? '',
    );
  }

  /// Picks the Arabic value (app is Arabic-first), falling back to English,
  /// then to the raw string. Handles both `{ar, en}` maps and plain strings.
  static String _localized(dynamic raw) {
    if (raw is Map) {
      final ar = raw['ar']?.toString();
      if (ar != null && ar.trim().isNotEmpty) return ar;
      final en = raw['en']?.toString();
      if (en != null && en.trim().isNotEmpty) return en;
      return '';
    }
    return raw?.toString() ?? '';
  }

  /// Maps a numeric phone country code to a display country name.
  /// Returns '' when the code is unknown so the UI shows nothing rather than
  /// a hardcoded country.
  static String _countryFromCode(String? code) {
    const map = <String, String>{
      '966': 'Saudi Arabia',
    };
    return map[code?.trim()] ?? '';
  }

  static List<ContractNoteEntity> _parseNotes(Map<String, dynamic> json) {
    final List<ContractNoteEntity> notes = [];

    // Parse Publisher Notes -> force userType='publisher'
    if (json['contr_pub_notes'] != null && json['contr_pub_notes'] is List) {
      for (var note in json['contr_pub_notes']) {
        if (note is Map) {
          notes.add(
            ContractNoteModel.fromJson(
              Map<String, dynamic>.from(note),
              userType: 'publisher',
            ),
          );
        }
      }
    }

    // Parse Customer Notes -> force userType='customer'
    if (json['contr_cust_notes'] != null && json['contr_cust_notes'] is List) {
      for (var note in json['contr_cust_notes']) {
        if (note is Map) {
          notes.add(
            ContractNoteModel.fromJson(
              Map<String, dynamic>.from(note),
              userType: 'customer',
            ),
          );
        }
      }
    }

    // Sort by date descending
    notes.sort((a, b) => b.dateOfNote.compareTo(a.dateOfNote));
    return notes;
  }

  static List<String> _parseDaysAvailability(Map<String, dynamic> json) {
    try {
      final daysString = json['advertisement']?['days_availability'];
      if (daysString != null && daysString is String) {
        final List<dynamic> parsed = jsonDecode(daysString);
        return parsed.map((e) => e.toString()).toList();
      }
    } catch (e) {
      // ignore error
    }
    return [];
  }

  /// Helper to derive status from raw API fields
  ///
  /// Backend flow uses one field: contract_status
  /// initiated -> opened (auto) -> inProgress -> completed
  static ContractStatus deriveStatus(Map<String, dynamic> json) {
    return ContractStatusMapper.fromString(
      json['contract_status']?.toString(),
    );
  }
}

class ContractNoteModel extends ContractNoteEntity {
  const ContractNoteModel({
    super.note,
    required super.dateOfNote,
    required super.creator,
    required super.userType,
  });

  factory ContractNoteModel.fromJson(
    Map<String, dynamic> json, {
    String? userType,
  }) {
    return ContractNoteModel(
      note: json['note']?.toString(),
      dateOfNote:
          DateTime.tryParse(json['date_of_note']?.toString() ?? '') ??
              DateTime.now(),
      creator: json['creator']?.toString() ?? '',
      // Source list determines the author (pub vs cust); the API's own
      // user_type field is empty, so the override takes precedence.
      userType: userType ?? json['user_type']?.toString() ?? '',
    );
  }
}
