import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAuth.instance.signOut();
  });
  testWidgets("Create Account Flow", (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TicTokApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text("Sign up for TikTok"), findsOneWidget);
    expect(find.text("Log in"), findsOneWidget);
    await tester.tap(find.text("Log in"));
    await tester.pumpAndSettle(const Duration(seconds: 5));
    final signUp = find.text("Sign up");
    await tester.tap(signUp);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final emailButton = find.text("Use email & password");
    expect(emailButton, findsOneWidget);
    await tester.tap(emailButton);
    // expect(find.text("Log in"), findsOneWidget);
    await tester.pumpAndSettle();
    final usernameInput = find.byType(TextField).first;
    await tester.enterText(usernameInput, "test");
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    final emailInput = find.byType(TextField).first;
    await tester.enterText(emailInput, "test@testing.com");
    // expect(find.text("Log in"), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    final passwordInput = find.byType(TextField).first;
    await tester.enterText(passwordInput, "password");
    // expect(find.text("Log in"), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
