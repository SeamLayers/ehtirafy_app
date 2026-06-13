import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_entity.dart';

/// Helper to parse localized fields that can be either String or Map with ar/en keys
String _parseLocalizedField(dynamic field) {
  if (field == null) return '';
  if (field is String) return field;
  if (field is Map) {
    // Prefer Arabic, fallback to English
    return field['ar']?.toString() ?? field['en']?.toString() ?? '';
  }
  return field.toString();
}

/// Contract model with mapping from API naming to app naming
/// API uses: freelancer (photographer), customer (client)
/// App uses: photographer (freelancer), client (customer)
class ContractModel extends ContractEntity {
  const ContractModel({
    required super.id,
    required super.advertisementId,
    required super.photographerId,
    required super.clientId,
    required super.requestedAmount,
    required super.actualAmount,
    super.contractStatus,
    required super.createdAt,
    required super.updatedAt,
    super.serviceTitle,
    super.photographerName,
    super.photographerImage,
    super.clientName,
    super.clientImage,
    super.chatMessages,
  });

  /// Parse from API JSON with mapping:
  /// - publisher_id → photographerId
  /// - customer_id → clientId
  /// - publisher.name → photographerName
  /// - customer.name → clientName
  factory ContractModel.fromJson(Map<String, dynamic> json) {
    // Parse chat messages from contr_cust_notes and contr_pub_notes
    List<Map<String, dynamic>> parsedMessages = [];

    // Parse customer notes
    if (json['contr_cust_notes'] != null) {
      try {
        if (json['contr_cust_notes'] is List) {
          for (var note in json['contr_cust_notes']) {
            if (note is Map<String, dynamic> &&
                note['note'] != null &&
                note['note'].toString().isNotEmpty) {
              parsedMessages.add({
                'note': note['note'] ?? '',
                'date': note['date_of_note'] ?? '',
                'creator': note['creator'] ?? '',
                'user_type': note['user_type'] ?? 'customer',
              });
            }
          }
        }
      } catch (_) {}
    }

    // Parse publisher/freelancer notes
    if (json['contr_pub_notes'] != null) {
      try {
        if (json['contr_pub_notes'] is List) {
          for (var note in json['contr_pub_notes']) {
            if (note is Map<String, dynamic> &&
                note['note'] != null &&
                note['note'].toString().isNotEmpty) {
              parsedMessages.add({
                'note': note['note'] ?? '',
                'date': note['date_of_note'] ?? '',
                'creator': note['creator'] ?? '',
                'user_type': note['user_type'] ?? 'freelancer',
              });
            }
          }
        }
      } catch (_) {}
    }

    // Sort messages by date
    parsedMessages.sort((a, b) {
      try {
        final dateA = DateTime.tryParse(a['date'] ?? '') ?? DateTime(1970);
        final dateB = DateTime.tryParse(b['date'] ?? '') ?? DateTime(1970);
        return dateA.compareTo(dateB);
      } catch (_) {
        return 0;
      }
    });

    // Type-guard nested objects before indexing so a non-Map value
    // (List/String/null) can't crash the parse with a NoSuchMethodError.
    final advertisement = json['advertisement'] is Map
        ? json['advertisement'] as Map
        : const {};
    final publisher = json['publisher'] is Map
        ? json['publisher'] as Map
        : const {};
    final customer = json['customer'] is Map
        ? json['customer'] as Map
        : const {};

    // Contract photos are not yet part of the contracts-relative payload, so
    // we source the display image from the nested advertisement's images list.
    // The nested advertisement currently has NO "images" key, so this resolves
    // to '' (branded placeholder) until the backend includes it. We never use a
    // static asset or fake URL here.
    final advertisementImages = advertisement['images'];
    final String serviceImage =
        (advertisementImages is List && advertisementImages.isNotEmpty)
        ? advertisementImages.first?.toString() ?? ''
        : '';

    return ContractModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      advertisementId: json['advertisement_id']?.toString() ?? '',
      // API mapping: publisher → photographer
      photographerId: json['publisher_id']?.toString() ?? '',
      // API mapping: customer → client
      clientId: json['customer_id']?.toString() ?? '',
      requestedAmount: json['requested_amount']?.toString() ?? '0',
      actualAmount: json['actual_amount']?.toString() ?? '0',
      contractStatus: json['contract_status']?.toString(),
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      // Service/Advertisement details - title can be String or Map with localized values
      serviceTitle: _parseLocalizedField(advertisement['title']),
      // Photographer (freelancer) details.
      // publisher has NO avatar/image field in the contracts payload, so the
      // card image comes from the advertisement images (currently '' = branded
      // placeholder) rather than a non-existent publisher['image'].
      photographerName: _parseLocalizedField(publisher['name']),
      photographerImage: serviceImage,
      // Client (customer) details.
      // customer also has NO avatar/image field; reuse the advertisement image
      // (or '' branded placeholder) rather than a non-existent customer['image'].
      clientName: _parseLocalizedField(customer['name']),
      clientImage: serviceImage,
      // Chat messages from notes
      chatMessages: parsedMessages.isNotEmpty ? parsedMessages : null,
    );
  }

  /// Convert to JSON for API requests
  /// Uses API naming: publisher_id, customer_id
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'advertisement_id': advertisementId,
      'publisher_id': photographerId, // App → API mapping
      'customer_id': clientId, // App → API mapping
      'requested_amount': requestedAmount,
      'actual_amount': actualAmount,
      'contract_status': contractStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create request body for initial contract creation
  static Map<String, dynamic> createRequestBody({
    required String advertisementId,
    required String photographerId,
    required String clientId,
    required String amount,
  }) {
    return {
      'advertisement_id': advertisementId,
      'publisher_id': photographerId, // API expects publisher_id
      'customer_id': clientId, // API expects customer_id
      'requested_amount': amount,
      'actual_amount': amount,
      'contract_status': 'initiated',
    };
  }

  /// Create request body for status update
  ///
  /// Backend uses `contract_status` with strict status casing and requires
  /// `user_type` for actor context on updates.
  static Map<String, dynamic> createStatusUpdateBody({
    required bool isPhotographer,
    required String status,
    String? noteText,
  }) {
    final userType = isPhotographer ? 'freelancer' : 'customer';

    final body = <String, dynamic>{
      '_method': 'put',
      'contract_status': _normalizeContractStatus(
        status,
        isPhotographer: isPhotographer,
      ),
      'user_type': userType,
      // Keep note_type for backwards compatibility on older backend payload parsers.
      'note_type': userType,
    };

    if (noteText != null && noteText.isNotEmpty) {
      body['note_text'] = noteText;
    }

    return body;
  }

  static String _normalizeContractStatus(
    String rawStatus, {
    required bool isPhotographer,
  }) {
    final normalized = rawStatus.trim().toLowerCase();

    switch (normalized) {
      case 'initiate':
      case 'initiated':
        return 'Initiate';
      case 'approved':
        return 'Approved';
      case 'inprogress':
      case 'in_process':
      case 'inprocess':
        // Backend transition from Initiate is Approved when the freelancer acts.
        return isPhotographer ? 'Approved' : 'InProgress';
      case 'completed':
      case 'closed':
        return 'Completed';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
      case 'canceled':
        return 'Cancelled';
      default:
        return rawStatus;
    }
  }
}
