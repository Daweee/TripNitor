import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tripnitor_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:tripnitor_mobile_app/features/auth/presentation/pages/login_user_page.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'injection_container.dart' as di;

void main() async {
    await dotenv.load(fileName: ".env");
    await di.init();
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MultiBlocProvider(
            providers: [
                BlocProvider<AuthBloc>(
                    create: (context) => di.sl<AuthBloc>(),
                ),
            ],
          child: MaterialApp(
              title: 'TripNitor',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
              ),
              home: AuthPage(),
          ),
        );
    }
}

