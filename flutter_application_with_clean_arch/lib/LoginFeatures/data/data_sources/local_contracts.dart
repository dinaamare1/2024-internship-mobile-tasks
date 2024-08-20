import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../models/user_model.dart';

abstract class LocalContracts {
  Future<Either<Failure, UserModel>> GetUser();
  Future<Either<Failure, UserModel>> SaveUser(UserModel user);
}