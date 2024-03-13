import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:workmateapp/pages/register_page.dart';
import 'package:workmateapp/services/firebase_service.dart';

class MockFirebaseService extends Mock implements FirebaseService {}

void main() {
  // Setup GetIt
  setUpAll(() {
    // Rejestrujemy mocka jako instancję FirebaseService
    GetIt.instance.registerSingleton<FirebaseService>(MockFirebaseService());
  });
  testWidgets('RegisterPage has a title, form fields, and register button',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterPage()));

    // Verify if title, form fields, and buttons are found
    expect(find.text('WorkMate'), findsOneWidget);
    expect(find.text('Register'), findsWidgets);
    expect(find.byType(TextFormField),
        findsNWidgets(3)); // Name, Email, Password fields// Register button
  });
}
