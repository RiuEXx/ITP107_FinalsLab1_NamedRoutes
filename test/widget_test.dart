import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:waypoint/main.dart';

/// Finds the text field whose label is [label].
Finder field(String label) => find.widgetWithText(TextFormField, label);

Future<void> tapText(WidgetTester tester, String text) async {
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await tester.tap(target);
  await tester.pumpAndSettle();
}

Future<void> signUp(
  WidgetTester tester, {
  required String name,
  required String email,
  String password = 'secret123',
}) async {
  await tapText(tester, 'Sign Up');
  await tester.enterText(field('Full name'), name);
  await tester.enterText(field('Email'), email);
  await tester.enterText(field('Password'), password);
  await tester.enterText(field('Confirm password'), password);
  await tapText(tester, 'Sign Up');
}

Future<void> logOut(WidgetTester tester) async {
  await tapText(tester, 'Logout');
  await tapText(tester, 'Log out');
}

void main() {
  setUp(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1170, 2532);
    view.devicePixelRatio = 3;
    addTearDown(view.reset);
  });

  testWidgets('app opens on the Login screen', (tester) async {
    await tester.pumpWidget(const WaypointApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(field('Email or username'), findsOneWidget);
    expect(field('Password'), findsOneWidget);
  });

  testWidgets('Sign Up link opens Sign-Up, and Log In pops back', (
    tester,
  ) async {
    await tester.pumpWidget(const WaypointApp());
    await tester.pumpAndSettle();

    await tapText(tester, 'Sign Up');
    expect(find.text('Create account'), findsOneWidget);
    expect(field('Confirm password'), findsOneWidget);

    await tapText(tester, 'Log In');
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Create account'), findsNothing);
  });

  testWidgets('full flow: Sign-Up passes the name to Home, Logout returns to '
      'Login', (tester) async {
    await tester.pumpWidget(const WaypointApp());
    await tester.pumpAndSettle();

    await signUp(tester, name: 'Maria Clara', email: 'maria@example.com');
    expect(find.text('Welcome, Maria Clara!'), findsOneWidget);
    expect(find.text('maria@example.com'), findsOneWidget);

    await logOut(tester);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('You have been logged out.'), findsOneWidget);
  });

  testWidgets('logging in with a created account opens Home with its name', (
    tester,
  ) async {
    await tester.pumpWidget(const WaypointApp());
    await tester.pumpAndSettle();

    await signUp(
      tester,
      name: 'Crisostomo Ibarra',
      email: 'ibarra@example.com',
    );
    await logOut(tester);

    // Log in with the username (the part before the @).
    await tester.enterText(field('Email or username'), 'ibarra');
    await tester.enterText(field('Password'), 'secret123');
    await tapText(tester, 'Login');

    expect(find.text('Welcome, Crisostomo Ibarra!'), findsOneWidget);
    expect(find.text('Good to see you again.'), findsOneWidget);
  });

  testWidgets('Login rejects unknown accounts and wrong passwords', (
    tester,
  ) async {
    await tester.pumpWidget(const WaypointApp());
    await tester.pumpAndSettle();

    await tapText(tester, 'Login');
    expect(find.text('Enter your email or username.'), findsOneWidget);

    await tester.enterText(field('Email or username'), 'nobody@example.com');
    await tester.enterText(field('Password'), 'whatever');
    await tapText(tester, 'Login');
    expect(
      find.text('No account found. Tap Sign Up to create one.'),
      findsOneWidget,
    );

    await signUp(tester, name: 'Sisa', email: 'sisa@example.com');
    await logOut(tester);
    await tester.enterText(field('Email or username'), 'sisa@example.com');
    await tester.enterText(field('Password'), 'wrong-password');
    await tapText(tester, 'Login');
    expect(find.text('Incorrect password.'), findsOneWidget);
  });

  testWidgets('Sign-Up validates every field', (tester) async {
    await tester.pumpWidget(const WaypointApp());
    await tester.pumpAndSettle();

    await tapText(tester, 'Sign Up');
    await tapText(tester, 'Sign Up');
    expect(find.text('Enter your full name.'), findsOneWidget);
    expect(find.text('Enter your email.'), findsOneWidget);
    expect(find.text('Use at least 6 characters.'), findsOneWidget);
    expect(find.text('Re-enter your password.'), findsOneWidget);

    await tester.enterText(field('Email'), 'not-an-email');
    await tester.enterText(field('Password'), 'secret123');
    await tester.enterText(field('Confirm password'), 'different');
    await tapText(tester, 'Sign Up');
    expect(
      find.text('Enter a valid email, like you@example.com.'),
      findsOneWidget,
    );
    expect(find.text('Passwords do not match.'), findsOneWidget);
  });
}
