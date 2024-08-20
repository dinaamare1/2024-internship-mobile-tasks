import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../entities/user_entities.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> logIn(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String name);
}