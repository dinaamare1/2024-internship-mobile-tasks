import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/failure.dart';
import '../models/user_model.dart';
import 'local_contracts.dart';

class LocalDataSourcesImp implements LocalContracts {
  final SharedPreferences sharedPreferences;

  LocalDataSourcesImp(this.sharedPreferences);

  @override
  Future<Either<Failure, UserModel>> GetUser() async {
    try {
      final user = sharedPreferences.getString('cachedUser');
      if (user != null) {
        final Map<String, dynamic> userMap = json.decode(user) as Map<String, dynamic>;
        return Right(UserModel.fromJson(userMap));
      } else {
        return Left(CacheFailure("No user found in cache"));
      }
    } catch (e) {
      return Left(CacheFailure("Failed to retrieve user from cache"));
    }
  }

  @override
  Future<Either<Failure, UserModel>> SaveUser(UserModel user) async {
    try {
      await sharedPreferences.setString('cachedUser', json.encode(user.toJson()));
      return Right(user);
    } catch (e) {
      return Left(CacheFailure("Failed to cache user"));
    }
  }
  
  @override
  Future<Either<Failure, void>> DeleteUser() {
    if (sharedPreferences.containsKey('cachedUser')) {
      sharedPreferences.remove('cachedUser');
      return Future.value(Right(null));
    } else {
      return Future.value(Left(CacheFailure("No user found in cache")));
    }
  }
}
