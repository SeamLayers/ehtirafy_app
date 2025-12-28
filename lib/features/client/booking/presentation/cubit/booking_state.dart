part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

/// Booking/Contract created successfully
class BookingSuccess extends BookingState {
  /// The created contract entity
  final ContractEntity contract;

  const BookingSuccess(this.contract);

  @override
  List<Object?> get props => [contract];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
