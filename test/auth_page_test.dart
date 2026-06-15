import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mitumba_ui/mitumba_ui.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  group('AuthPage', () {
    testWidgets('renders sign in form by default', (tester) async {
      await tester.pumpWidget(wrap(const AuthPage()));

      expect(find.text('Sign In'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('renders sign up form when view is signup', (tester) async {
      await tester.pumpWidget(wrap(const AuthPage(view: AuthView.signup)));

      expect(find.text('Sign Up'), findsWidgets);
    });

    testWidgets('renders forgot password form', (tester) async {
      await tester.pumpWidget(wrap(const AuthPage(view: AuthView.forgot)));

      expect(find.text('Forgot Password'), findsOneWidget);
      expect(find.text('Send Reset Link'), findsOneWidget);
    });

    testWidgets('calls onLogin when sign in button is tapped', (tester) async {
      String? email;
      await tester.pumpWidget(wrap(AuthPage(
        onLogin: (e, p, r) => email = e,
      )));

      await tester.enterText(find.widgetWithText(TextField, 'Email'), 'test@test.com');
      await tester.tap(find.text('Sign In').last);
      await tester.pump();
      expect(email, 'test@test.com');
    });

    testWidgets('shows error message', (tester) async {
      await tester.pumpWidget(wrap(const AuthPage(error: 'Invalid credentials')));

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('switches to forgot password view', (tester) async {
      AuthView? changedTo;
      await tester.pumpWidget(wrap(AuthPage(onViewChange: (v) => changedTo = v)));

      await tester.tap(find.text('Forgot password?'));
      await tester.pump();
      expect(changedTo, AuthView.forgot);
      expect(find.text('Forgot Password'), findsOneWidget);
    });
  });
}
