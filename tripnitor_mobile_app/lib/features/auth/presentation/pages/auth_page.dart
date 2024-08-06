import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripnitor_mobile_app/features/auth/domain/usecases/login_user.dart';
import 'package:tripnitor_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

import 'login_user_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
            if (state is AuthInitial || state is Unauthenticated) {
                return LoginUserPage();
            } else if (state is Authenticated) {
                return Placeholder();
            } else if (state is AuthLoading) {
                return Center(child: CircularProgressIndicator());
            } else if (state is AuthError) {
                return Center(child: Text(state.message));
            } else {
                return Placeholder();    
            }
        },     
    );
  }
}