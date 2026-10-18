import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/app.dart';
import 'package:flutterapp/features/auth/auth_controller.dart';
import 'package:flutterapp/features/auth/login_screen.dart';

void main() {
  testWidgets('signed-out user lands on the Login screen', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => Stream<User?>.value(null)),
        ],
        child: const VestaApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}