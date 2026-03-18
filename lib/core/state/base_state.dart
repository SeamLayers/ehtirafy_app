import 'package:equatable/equatable.dart';

abstract class BaseState<T> extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => const [];
}

class BaseInitial<T> extends BaseState<T> {
  const BaseInitial();
}

class BaseLoading<T> extends BaseState<T> {
  const BaseLoading();
}

class BaseSuccess<T> extends BaseState<T> {
  final T data;

  const BaseSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class BaseError<T> extends BaseState<T> {
  final String message;

  const BaseError(this.message);

  @override
  List<Object?> get props => [message];
}