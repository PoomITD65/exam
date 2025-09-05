import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'app_routes.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth UI',
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginPage(),
        AppRoutes.signUp: (_) => const SignUpPage(),
        AppRoutes.forgot: (_) => const ForgotPasswordPage(),
      },
    );
  }
}
