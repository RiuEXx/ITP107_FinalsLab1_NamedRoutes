import 'package:flutter/material.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';

/// Data passed to the Home screen through the route's `arguments`.
class HomeArgs {
  const HomeArgs({
    required this.fullName,
    required this.email,
    this.isNewAccount = false,
  });

  final String fullName;
  final String email;

  /// True when the user arrived from Sign-Up, false when they logged in.
  final bool isNewAccount;
}

/// Every named route in the app, and how each one is built.
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String signUp = '/signup';
  static const String home = '/home';

  /// Called by MaterialApp for every Navigator.pushNamed / pushReplacementNamed
  /// / pushNamedAndRemoveUntil. It reads the route name and its arguments and
  /// returns the matching screen.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        // An optional message, e.g. "You have been logged out."
        final notice = settings.arguments is String
            ? settings.arguments as String
            : null;
        return _buildRoute(settings, LoginScreen(notice: notice));

      case signUp:
        return _buildRoute(settings, const SignUpScreen());

      case home:
        final args = settings.arguments;
        if (args is HomeArgs) {
          return _buildRoute(settings, HomeScreen(args: args));
        }
        // Home needs a signed-in user. Without one, send them to Login.
        return _buildRoute(
          const RouteSettings(name: login),
          const LoginScreen(),
        );
    }
    // Unknown names fall through to onUnknownRoute.
    return null;
  }

  /// Any route name that does not exist opens the Login screen.
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return _buildRoute(const RouteSettings(name: login), const LoginScreen());
  }

  /// The shared screen transition: the new screen fades in while sliding up
  /// slightly.
  static Route<dynamic> _buildRoute(RouteSettings settings, Widget screen) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.05),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
