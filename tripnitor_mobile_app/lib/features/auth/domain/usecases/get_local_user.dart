import 'package:dartz/dartz.dart';
import 'package:tripnitor_mobile_app/core/usecases/usecase.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/auth_user_model.dart';
import '../repositories/auth_repository.dart';

class GetLocalUser implements Usecase<AuthUserModel, NoParams> {
  final AuthRepository repository;

  GetLocalUser(this.repository);

  @override
  Future<Either<Failure, AuthUserModel>> call(NoParams params) async {
    try {
      final user = await repository.getLocalUser();
      return user.fold(
        (failure) => Left(failure),
        (authUserModel) => Right(authUserModel),
      );
    } on Exception {
      return Left(CacheFailure());
    }
  }
} 