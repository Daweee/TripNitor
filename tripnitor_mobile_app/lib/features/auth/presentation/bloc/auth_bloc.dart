import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/auth_token_model.dart';
import '../../data/models/auth_user_model.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/usecases/get_local_token.dart';
import '../../domain/usecases/get_local_user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/logout_user.dart';
import '../../domain/usecases/register_user.dart';
import 'package:tripnitor_mobile_app/core/usecases/usecase.dart' as NoParams;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
    final GetLocalUser getLocalUser;
    final GetLocalToken getLocalToken;
    final LoginUser loginUser;
    final RegisterUser registerUser;
    final LogoutUser logoutUser;

    AuthBloc({
        required this.getLocalUser,
        required this.getLocalToken,
        required this.loginUser,
        required this.registerUser,
        required this.logoutUser,
    }) : super(AuthInitial()) {
        on<CheckAuthStatus>(_onCheckAuthStatus);
        on<LoginRequested>(_onLoginRequested);
        on<RegisterRequested>(_onRegisterRequested);
        on<LogoutRequested>(_onLogoutRequested);
    }

    Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
        emit(AuthLoading());
        final tokenResult = await getLocalToken(NoParams.NoParams());
        final userResult = await getLocalUser(NoParams.NoParams());  

        final isAuthenticated = tokenResult.fold(
            (failure) => false,
            (token) => token.access.isNotEmpty,
        );     

        if (isAuthenticated) {
            userResult.fold(
                (failure) => emit(AuthError("Failed to retrieve user data")),
                (user) {
                    tokenResult.fold(
                        (failure) => emit(AuthError("Failed to retrieve token")),
                        (token) => emit(AuthenticatedWithNullableToken(user: user, token: token)),
                    );
                },
            );
        } else {
            emit(Unauthenticated());
        }
    }

    Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
        emit(AuthLoading());
        final params = LoginParams(username: event.username, password: event.password);
        print("Login attempt with username: ${event.username}");
        final result = await loginUser(params);
        result.fold(
            (failure) => print("Login failed with error: $failure"),
            (success) => print("Login succeeded")
        );
        emit(_eitherLoadedOrErrorState(result));
    }



    Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
        emit(AuthLoading());
        final params = RegisterParams(
            username: event.username,
            email: event.email,
            password: event.password,
            name: event.name,
            phoneNumber: event.phoneNumber,
        );
        final result = await registerUser(params);
        emit(_eitherLoadedOrErrorState(result));
    }

    Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
        emit(AuthLoading());
        final param = LogoutParams(token: event.token);
        final result = await logoutUser(param);
        emit(result.fold(
            (failure) => AuthError(_mapFailureToMessage(failure)),
            (_) => Unauthenticated(),
        ));
    }

    AuthState _eitherLoadedOrErrorState(Either<Failure, AuthResponse> result) {
        return result.fold(
            (failure) => AuthError(_mapFailureToMessage(failure)),
            (response) => Authenticated(response: response),
        );
    }

    String _mapFailureToMessage(Failure failure) {
        switch (failure.runtimeType) {
            case ServerFailure:
                return 'Server error occurred';
            case NetworkFailure:
                return 'Network error occurred';
            default:
                return 'Unexpected error';
        }
    }
}
