import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../repository/user_repository.dart';
class LogoutUsecase {
  final UserRepository userRepository;
  LogoutUsecase({required this.userRepository});
  Future<Either<Failure, void>> execute() {
    return userRepository.logOut();
  }
}