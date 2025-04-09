import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:tripnitor_mobile_app/core/constants/constant.dart';
import 'package:logger/logger.dart';
import 'package:tripnitor_mobile_app/pages/login_page.dart';
import 'pages/auth_page.dart';
import 'providers/auth_provider.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  if (StripeConfig.STRIPE_PUBLISHABLE_KEY != null &&
      StripeConfig.STRIPE_PUBLISHABLE_KEY!.isNotEmpty) {
    Stripe.publishableKey = StripeConfig.STRIPE_PUBLISHABLE_KEY!;
    await Stripe.instance.applySettings();
  } else {
    logger.w('Stripe publishable key is not set');
  }

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TripNitor',
      home: authState.isAuthenticated ? AuthPage() : LoginPage(),
    );
  }
}
