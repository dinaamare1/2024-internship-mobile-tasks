import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../models/user_model.dart';

abstract class RemoteContrats {
  Future<Either<Failure, UserModel>> logIn(String email, String password);
  Future<Either<Failure, UserModel>> register(String email, String password, String name);
}