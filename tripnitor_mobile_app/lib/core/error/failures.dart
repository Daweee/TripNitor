import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
    Failure([List properties = const <dynamic>[]]) : super();
}

class ServerFailure extends Failure {
    final String message;
    final int? statusCode;

    ServerFailure({required this.message, this.statusCode});

    @override
    String toString() => 'ServerFailure(message: $message, statusCode: $statusCode)';

    @override
    // TODO: implement props
    List<Object?> get props => throw UnimplementedError();
    }
class CacheFailure extends Failure {
    @override
    List<Object> get props => [];
}

class NetworkFailure extends Failure {
    @override
    List<Object> get props => [];
}
