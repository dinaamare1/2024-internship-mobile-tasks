import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../core/error/failure.dart';
import '../models/user_model.dart';
import 'remote_contrats.dart';

class RemoteDataSourcesImp implements RemoteContrats {
  
  final http.Client client;

  RemoteDataSourcesImp({required this.client});

  @override
  Future<Either<Failure, UserModel>> register(String email, String password, String name) async {
    try {
      final response = await client.post(
        Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v2/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );
      if (response.statusCode == 201) {
        final userJson = json.decode(response.body)['data'];
        final userModel = UserModel.fromJson(userJson as Map<String, dynamic>);
        return Right(userModel);
      }
      else {
        return Left(ServerFailure('user already exist'));
      }
    } catch (e) {
      return Left(ServerFailure('Failed to register'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> logIn(String email, String password) async {
    try {
      final response = await client.post(
        Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v2/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        final String accessToken = responseBody['data']['access_token'];

        final userResponse = await client.get(
          Uri.parse('https://g5-flutter-learning-path-be.onrender.com/api/v2/users/me'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (userResponse.statusCode == 200) {
          final userJson = json.decode(userResponse.body)['data'];
          final userModel = UserModel.fromJson(userJson as Map<String, dynamic>);
          return Right(userModel);
        } else {
          return Left(ServerFailure("Failed to login because of token"));
        }
      } else {
        return Left(ServerFailure("Failed to login because of login response"));
      }
    } catch (e) {
      return Left(ServerFailure("Failed to login"));
    }
  }
}
