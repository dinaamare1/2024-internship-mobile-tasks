import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../entities/user_entities.dart';
import '../repository/user_repository.dart';
class RegisterUsecase {
  final UserRepository userRepository;
  RegisterUsecase({required this.userRepository});
  Future<Either<Failure, User>> execute(String email, String password, String name) {
    return userRepository.register(email, password, name);
  }
}