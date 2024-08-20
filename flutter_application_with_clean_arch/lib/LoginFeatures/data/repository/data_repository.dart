import '../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../core/network/network_info.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/repository/user_repository.dart';
import '../data_sources/local_contracts.dart';
import '../data_sources/remote_contrats.dart';

class UserProductRepository implements UserRepository{
  final RemoteContrats remoteContrats;
  final LocalContracts localContrats;
  final NetworkInfo networkInfo;

  UserProductRepository({
    required this.remoteContrats,
    required this.localContrats,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> logIn(String email, String password) async {
    if (await networkInfo.isConnected()) {
      try {
        final loggedInUser = await remoteContrats.logIn(email, password);
        localContrats.SaveUser(loggedInUser.getOrElse(() => throw CacheFailure("failed to cache user")));
        return loggedInUser;
      } catch (e) {
        return Left(ServerFailure("Failed to login"));
      }
    } 
    else {
      try {
        final lastLoggedIn = await localContrats.GetUser();
          return lastLoggedIn.map((userModel) => userModel as User);
        } catch (e) {
        return Left(ServerFailure("failed to get cahed User"));}
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password, String name) async {
    if (await networkInfo.isConnected()) {
      try {
        final loggedInUser = await remoteContrats.register(email, password, name);
        print(loggedInUser);
        localContrats.SaveUser(loggedInUser.getOrElse(() => throw CacheFailure("failed to cache user")));
        return loggedInUser;
      } catch (e) {
        return Left(ServerFailure('Failed to registerss'));
      }
    } 
    else {
      try {
        final lastLoggedIn = await localContrats.GetUser();
          return lastLoggedIn.map((userModel) => userModel as User);
        } catch (e) {
        return Left(ServerFailure("user Not found because it is not registered first"));}
    }
  }
}