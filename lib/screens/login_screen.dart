import 'package:flutter/material.dart';

import '../data/account_store.dart';
import '../routes/app_routes.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_switch_prompt.dart';
import '../widgets/brand_header.dart';
import '../widgets/content_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.notice});

  /// A message shown once when the screen opens, e.g. after logging out.
  final String? notice;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _identifierError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    final notice = widget.notice;
    if (notice != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(notice)),
              ],
            ),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      _identifierError = null;
      _passwordError = null;
    });
    if (!_formKey.currentState!.validate()) return;

    final account = AccountStore.find(_identifierController.text);
    if (account == null) {
      setState(
        () => _identifierError = 'No account found. Tap Sign Up to create one.',
      );
      return;
    }
    if (account.password != _passwordController.text) {
      setState(() => _passwordError = 'Incorrect password.');
      return;
    }

    // Replace Login with Home, so the back button cannot return to Login.
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.home,
      arguments: HomeArgs(fullName: account.fullName, email: account.email),
    );
  }

  void _goToSignUp() {
    // Push Sign-Up on top of Login, so Sign-Up can pop back here.
    Navigator.pushNamed(context, AppRoutes.signUp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverlappingLayout(
        header: const BrandHeader(
          showBrandMark: false,
          centerChild: true,
          child: AuthHero(),
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
                      title: 'Welcome back',
                      subtitle: 'Log in to continue where you left off.',
                    ),
                    AppTextField(
                      controller: _identifierController,
                      label: 'Email or username',
                      hint: 'you@example.com',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [
                        AutofillHints.email,
                        AutofillHints.username,
                      ],
                      errorText: _identifierError,
                      onChanged: (_) => setState(() => _identifierError = null),
                      validator: (value) => (value ?? '').trim().isEmpty
                          ? 'Enter your email or username.'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.password],
                      errorText: _passwordError,
                      onChanged: (_) => setState(() => _passwordError = null),
                      onSubmitted: (_) => _login(),
                      validator: (value) =>
                          (value ?? '').isEmpty ? 'Enter your password.' : null,
                    ),
                    const SizedBox(height: 28),
                    FilledButton(onPressed: _login, child: const Text('Login')),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AuthSwitchPrompt(
            question: "Don't have an account?",
            actionLabel: 'Sign Up',
            onPressed: _goToSignUp,
          ),
        ],
      ),
    );
  }
}
