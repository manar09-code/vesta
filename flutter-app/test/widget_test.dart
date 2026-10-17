import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterapp/app.dart';

void main() {
  testWidgets('app starts with the bottom navigation', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: VestaApp()));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
  });
}
