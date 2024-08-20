import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../entities/user_entities.dart';
import '../repository/user_repository.dart';

class LoginUsecase {
  final UserRepository useRepository;
  
  LoginUsecase({required this.useRepository});

  Future<Either<Failure, User>> execute(String email, String password) {
    return useRepository.logIn(email, password);
  }
}