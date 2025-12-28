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
    super.contrPubStatus,
    super.contrCustStatus,
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
  });

  factory ContractDetailsModel.fromJson(Map<String, dynamic> json) {
    return ContractDetailsModel(
      id: json['id']?.toString() ?? '',
      status: deriveStatus(json),
      serviceTitle: json['advertisement']?['title'] is Map
          ? (json['advertisement']?['title']['en'] ?? '')
          : (json['advertisement']?['title'] ?? ''),
      serviceCategory: json['advertisement']?['category_id']?.toString() ?? '',
      description: json['advertisement']?['description'] is Map
          ? (json['advertisement']?['description']['en'] ?? '')
          : (json['advertisement']?['description'] ?? ''),
      location: 'Saudi Arabia', // Mock or parse if available
      date: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      budget:
          double.tryParse(json['requested_amount']?.toString() ?? '0') ?? 0.0,
      isPaymentDeposited: false,
      photographerName: json['publisher']?['name'] ?? '',
      photographerImage: json['publisher']?['image'] ?? '',
      approvedAt: json['approval_at'] != null
          ? DateTime.tryParse(json['approval_at'])
          : null,
      contractStatus: json['contract_status'],
      contrPubStatus: json['contr_pub_status'],
      contrCustStatus: json['contr_cust_status'],
      publisherId: json['publisher']?['id']?.toString() ?? '',
      publisherPhone: json['publisher']?['phone'] ?? '',
      publisherEmail: json['publisher']?['email'] ?? '',
      customerId: json['customer']?['id']?.toString() ?? '',
      customerName: json['customer']?['name'] ?? '',
      customerImage: json['customer']?['image'] ?? '',
      customerPhone: json['customer']?['phone'] ?? '',
      customerEmail: json['customer']?['email'] ?? '',
      notes: _parseNotes(json),
      daysAvailability: _parseDaysAvailability(json),
    );
  }

  static List<ContractNoteEntity> _parseNotes(Map<String, dynamic> json) {
    final List<ContractNoteEntity> notes = [];

    // Parse Publisher Notes
    if (json['contr_pub_notes'] != null && json['contr_pub_notes'] is List) {
      for (var note in json['contr_pub_notes']) {
        notes.add(ContractNoteModel.fromJson(note));
      }
    }

    // Parse Customer Notes
    if (json['contr_cust_notes'] != null && json['contr_cust_notes'] is List) {
      for (var note in json['contr_cust_notes']) {
        notes.add(ContractNoteModel.fromJson(note));
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
  static ContractStatus deriveStatus(Map<String, dynamic> json) {
    final contractStatus = json['contract_status']?.toString().toLowerCase();
    final pubStatus = json['contr_pub_status']?.toString().toLowerCase();
    final custStatus = json['contr_cust_status']?.toString().toLowerCase();

    if (pubStatus == 'rejected') return ContractStatus.cancelled; // or rejected
    if (custStatus == 'cancelled') return ContractStatus.cancelled;
    if (contractStatus == 'closed' ||
        pubStatus == 'completed' ||
        custStatus == 'completed') {
      return ContractStatus.completed;
    }

    if (pubStatus == 'approved') {
      if (custStatus == 'inprocess' ||
          custStatus == 'paid' ||
          custStatus == 'approved' ||
          custStatus == 'completed') {
        return ContractStatus.inProgress;
      }
      return ContractStatus.awaitingPayment;
    }

    return ContractStatus.underReview; // Default for initial / pending
  }
}

class ContractNoteModel extends ContractNoteEntity {
  const ContractNoteModel({
    super.note,
    required super.dateOfNote,
    required super.creator,
    required super.userType,
  });

  factory ContractNoteModel.fromJson(Map<String, dynamic> json) {
    return ContractNoteModel(
      note: json['note'],
      dateOfNote:
          DateTime.tryParse(json['date_of_note'] ?? '') ?? DateTime.now(),
      creator: json['creator'] ?? '',
      userType: json['user_type'] ?? '',
    );
  }
}
