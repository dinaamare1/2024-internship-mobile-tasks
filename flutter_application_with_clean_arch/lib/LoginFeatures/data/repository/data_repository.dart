import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/error/failure.dart';
import 'package:dartz/dartz.dart';

import '../../../core/network/network_info.dart';
import '../../domain/entities/user_entities.dart';
import '../../domain/repository/user_repository.dart';
import '../data_sources/local_contracts.dart';
import '../data_sources/remote_contrats.dart';

class UserProductRepository implements UserRepository {
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
        loggedInUser.fold(
          (failure) => throw CacheFailure("Failed to login"),
          (user) async => await localContrats.SaveUser(user),
        );
        print("User logged in");
        return loggedInUser;
      } catch (e) {
        return Left(ServerFailure("Failed to login"));
      }
    } else {
      try {
        final lastLoggedIn = await localContrats.GetUser();
        return lastLoggedIn;
      } catch (e) {
        return Left(CacheFailure("Failed to get cached user"));
      }
    }
  }

  @override
  Future<Either<Failure, User>> register(String email, String password, String name) async {
    if (await networkInfo.isConnected()) {
      try {
        final registeredUser = await remoteContrats.register(email, password, name);
        registeredUser.fold(
          (failure) => throw CacheFailure("Failed to register"),
          (user) async => await localContrats.SaveUser(user),
        );

        return registeredUser;
      } catch (e) {
        return Left(ServerFailure("Failed to register"));
      }
    } else {
      return Left(ServerFailure("No internet connection. Please connect to the internet to register."));
    }
  }
  
  @override
  Future<Either<Failure, void>> logOut() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey('cachedUser')) {
      sharedPreferences.remove('cachedUser');
      return Future.value(Right(null));
    } else {
      return Future.value(Left(CacheFailure("No user found in cache")));
    }
  }

  
}

