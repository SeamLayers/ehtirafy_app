import 'package:equatable/equatable.dart';

enum ContractStatus {
  inProgress,
  awaitingPayment,
  underReview,
  archived,
  completed,
  cancelled,
  rejected,
}

class ContractDetailsEntity extends Equatable {
  final String id;
  final ContractStatus status;
  final String serviceTitle;
  final String serviceCategory;
  final String description;
  final String location;
  final DateTime date;
  final double budget;
  final bool isPaymentDeposited;
  final String photographerName;
  final String photographerImage;
  final DateTime? approvedAt;
  final String? contractStatus;
  final String? contrPubStatus;
  final String? contrCustStatus;
  final String publisherId;
  final String publisherPhone;
  final String publisherEmail;
  final String customerId;
  final String customerName;
  final String customerImage;
  final String customerPhone;
  final String customerEmail;
  final List<ContractNoteEntity> notes;
  final List<String> daysAvailability;

  const ContractDetailsEntity({
    required this.id,
    required this.status,
    required this.serviceTitle,
    required this.serviceCategory,
    required this.description,
    required this.location,
    required this.date,
    required this.budget,
    required this.isPaymentDeposited,
    required this.photographerName,
    required this.photographerImage,
    this.approvedAt,
    this.contractStatus,
    this.contrPubStatus,
    this.contrCustStatus,
    this.publisherId = '',
    this.publisherPhone = '',
    this.publisherEmail = '',
    this.customerId = '',
    this.customerName = '',
    this.customerImage = '',
    this.customerPhone = '',
    this.customerEmail = '',
    this.notes = const [],
    this.daysAvailability = const [],
  });

  /// Chat allowed only for active contracts (in progress, under review, completed)
  /// Chat is NOT allowed for: awaiting payment (not started yet), cancelled, archived
  bool get isChatAllowed {
    return status == ContractStatus.inProgress ||
        status == ContractStatus.underReview ||
        status == ContractStatus.completed;
  }

  ContractDetailsEntity copyWith({
    String? id,
    ContractStatus? status,
    String? serviceTitle,
    String? serviceCategory,
    String? description,
    String? location,
    DateTime? date,
    double? budget,
    bool? isPaymentDeposited,
    String? photographerName,
    String? photographerImage,
    DateTime? approvedAt,
    String? contractStatus,
    String? contrPubStatus,
    String? contrCustStatus,
    String? publisherId,
    String? publisherPhone,
    String? publisherEmail,
    String? customerId,
    String? customerName,
    String? customerImage,
    String? customerPhone,
    String? customerEmail,
    List<ContractNoteEntity>? notes,
    List<String>? daysAvailability,
  }) {
    return ContractDetailsEntity(
      id: id ?? this.id,
      status: status ?? this.status,
      serviceTitle: serviceTitle ?? this.serviceTitle,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      budget: budget ?? this.budget,
      isPaymentDeposited: isPaymentDeposited ?? this.isPaymentDeposited,
      photographerName: photographerName ?? this.photographerName,
      photographerImage: photographerImage ?? this.photographerImage,
      approvedAt: approvedAt ?? this.approvedAt,
      contractStatus: contractStatus ?? this.contractStatus,
      contrPubStatus: contrPubStatus ?? this.contrPubStatus,
      contrCustStatus: contrCustStatus ?? this.contrCustStatus,
      publisherId: publisherId ?? this.publisherId,
      publisherPhone: publisherPhone ?? this.publisherPhone,
      publisherEmail: publisherEmail ?? this.publisherEmail,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerImage: customerImage ?? this.customerImage,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      notes: notes ?? this.notes,
      daysAvailability: daysAvailability ?? this.daysAvailability,
    );
  }

  @override
  List<Object?> get props => [
    id,
    status,
    serviceTitle,
    serviceCategory,
    description,
    location,
    date,
    budget,
    isPaymentDeposited,
    photographerName,
    photographerImage,
    approvedAt,
    contractStatus,
    contrPubStatus,
    contrCustStatus,
    publisherId,
    publisherPhone,
    publisherEmail,
    customerId,
    customerName,
    customerImage,
    customerPhone,
    customerEmail,
    notes,
    daysAvailability,
  ];
}

class ContractNoteEntity extends Equatable {
  final String? note;
  final DateTime dateOfNote;
  final String creator;
  final String userType;

  const ContractNoteEntity({
    this.note,
    required this.dateOfNote,
    required this.creator,
    required this.userType,
  });

  @override
  List<Object?> get props => [note, dateOfNote, creator, userType];
}
