import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:workmateapp/pages/login_page.dart';
import 'package:workmateapp/services/firebase_service.dart';

class MockFirebaseService extends Mock implements FirebaseService {}

void main() {
  setUpAll(() {
    // Rejestrujemy mocka jako instancję FirebaseService
    GetIt.instance.registerSingleton<FirebaseService>(MockFirebaseService());
  });
  testWidgets('LoginPage renders correctly', (WidgetTester tester) async {
    // Renderujemy LoginPage
    await tester.pumpWidget(MaterialApp(home: LoginPage()));

    // Sprawdzamy, czy wszystkie kluczowe widgety są renderowane
    expect(find.text('WorkMate'), findsOneWidget);
    expect(find.text('Email...'), findsOneWidget);
    expect(find.text('Password...'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text("Don't have an account?"), findsOneWidget);
  });
}
