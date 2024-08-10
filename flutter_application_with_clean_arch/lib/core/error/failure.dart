import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable{
  final String message;
  const Failure(this.message);
  @override
  List<Object> get props => [message];
}

abstract class ValidationFailure extends Failure {
  final String message;
  ValidationFailure(this.message) : super(message);
}