import 'package:dartz/dartz.dart';
import 'package:tripnitor_mobile_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:tripnitor_mobile_app/features/auth/data/models/auth_user_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_token_model.dart';

class AuthRepositoryImpl implements AuthRepository {
    final AuthRemoteDataSource remoteDataSource;
    final AuthLocalDataSource localDataSource;
    final NetworkInfo networkInfo;

    AuthRepositoryImpl({
        required this.remoteDataSource,
        required this.localDataSource,
        required this.networkInfo,
    });

    @override
    Future<Either<Failure, AuthResponse>> loginUser({required String username, required String password}) async {
        print('Is Connected: ${await networkInfo.isConnected}');
        if (await networkInfo.isConnected) {
            try {
                final remoteAuthReponse = await remoteDataSource.loginUser(username: username, password: password);
                localDataSource.cacheUser(remoteAuthReponse.user as AuthUserModel);
                localDataSource.cacheToken(remoteAuthReponse.token as AuthTokenModel);
                return Right(remoteAuthReponse);
            } on ServerException catch (e){
                return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
            }
        } else {
            return Left(NetworkFailure());
        }
    }

    @override
    Future<Either<Failure, AuthResponse>> logoutUser({required String token}) async {
        if (await networkInfo.isConnected) {
            try {
                final token = await localDataSource.getLastToken();
                final result = await remoteDataSource.logoutUser(token: token.access);
                if (result.status == 205) {
                    await localDataSource.clear();
                }
                return Right(result);
            } on ServerException catch (e) {
                return Left(ServerFailure(message: e.message));
            } on CacheException {
                return Left(CacheFailure());
            }
        } else {
            return Left(NetworkFailure());
        }
    }

    @override
    Future<Either<Failure, AuthResponse>> registerUser({
        required String username, 
        required String email, 
        required String password, 
        required String name, 
        required String phoneNumber}) async {
        if (await networkInfo.isConnected) {
            try {
                final remoteAuthReponse = await remoteDataSource.registerUser(
                    username: username,
                    email: email,
                    password: password,
                    name: name,
                    phoneNumber: phoneNumber,
                );
                localDataSource.cacheUser(remoteAuthReponse.user as AuthUserModel);
                localDataSource.cacheToken(remoteAuthReponse.token as AuthTokenModel);
                return Right(remoteAuthReponse);
            } on ServerException catch (e) {
                return Left(ServerFailure(message: e.message));
            }
        } else {
            return Left(NetworkFailure());
        }
    }

    @override
    Future<Either<Failure, AuthUserModel>> getLocalUser() async {
        try {
            final user = await localDataSource.getLastUser();
            return Right(user);
        } on CacheException {
            return Left(CacheFailure());
        }
    }
    
    @override
    Future<Either<Failure, AuthTokenModel>> getLocalToken() async {
        try {
            final token = await localDataSource.getLastToken();
            return Right(token);
        } on CacheException {
            return Left(CacheFailure());
        }
    }
}