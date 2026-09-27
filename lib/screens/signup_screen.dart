import 'package:flutter/material.dart';

import '../data/account_store.dart';
import '../routes/app_routes.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_switch_prompt.dart';
import '../widgets/brand_header.dart';
import '../widgets/content_card.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _emailError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _signUp() {
    setState(() => _emailError = null);
    if (!_formKey.currentState!.validate()) return;

    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (AccountStore.isEmailTaken(email)) {
      setState(
        () => _emailError = 'An account with this email already exists.',
      );
      return;
    }

    AccountStore.register(
      Account(
        fullName: fullName,
        email: email,
        password: _passwordController.text,
      ),
    );

    // Open Home and clear Login and Sign-Up from the stack. The entered name
    // travels to Home as a route argument.
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.home,
      (route) => false,
      arguments: HomeArgs(fullName: fullName, email: email, isNewAccount: true),
    );
  }

  void _backToLogin() {
    // Sign-Up was pushed on top of Login, so popping returns to it.
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverlappingLayout(
        header: BrandHeader(
          leading: IconButton(
            tooltip: 'Back to Login',
            onPressed: _backToLogin,
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          showBrandMark: false,
          centerChild: true,
          child: const AuthHero(),
        ),
        children: [
          ContentCard(
            child: Form(
              key: _formKey,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const FormHeading(
                      title: 'Create account',
                      subtitle: 'Join Waypoint to get started.',
                    ),
                    AppTextField(
                      controller: _nameController,
                      label: 'Full name',
                      hint: 'Juan Dela Cruz',
                      icon: Icons.badge_outlined,
                      textCapitalization: TextCapitalization.words,
                      autofillHints: const [AutofillHints.name],
                      validator: (value) {
                        final name = (value ?? '').trim();
                        if (name.isEmpty) return 'Enter your full name.';
                        if (name.length < 2) {
                          return 'That name looks too short.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@example.com',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      errorText: _emailError,
                      onChanged: (_) => setState(() => _emailError = null),
                      validator: (value) {
                        final email = (value ?? '').trim();
                        if (email.isEmpty) return 'Enter your email.';
                        if (!_emailPattern.hasMatch(email)) {
                          return 'Enter a valid email, like you@example.com.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'At least 6 characters',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (value) => (value ?? '').length < 6
                          ? 'Use at least 6 characters.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _confirmController,
                      label: 'Confirm password',
                      icon: Icons.lock_reset_rounded,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _signUp(),
                      validator: (value) {
                        if ((value ?? '').isEmpty) {
                          return 'Re-enter your password.';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    FilledButton(
                      onPressed: _signUp,
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AuthSwitchPrompt(
            question: 'Already have an account?',
            actionLabel: 'Log In',
            onPressed: _backToLogin,
          ),
        ],
      ),
    );
  }
}
