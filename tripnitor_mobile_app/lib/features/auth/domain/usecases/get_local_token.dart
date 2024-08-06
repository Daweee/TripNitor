import 'package:dartz/dartz.dart';
import 'package:tripnitor_mobile_app/core/usecases/usecase.dart';
import 'package:tripnitor_mobile_app/features/auth/data/models/auth_token_model.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class GetLocalToken implements Usecase<AuthTokenModel, NoParams> {
    final AuthRepository repository;

    GetLocalToken(this.repository);

    @override
    Future<Either<Failure, AuthTokenModel>> call(NoParams params) async {
        try {
            final token = await repository.getLocalToken();
            return token.fold(
              (failure) => Left(failure),
              (authToken) => Right(authToken),
            );
        } on Exception {
            return Left(CacheFailure());
        }
    }
}