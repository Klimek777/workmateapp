import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:workmateapp/main.dart' as app;

void main() {
  group("App test", () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('App test', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      //login logic
      final emailFormField = find.byType(TextFormField).first;
      final passwordFormField = find.byType(TextFormField).last;
      final logginButton = find.byType(MaterialButton).first;

      await tester.enterText(emailFormField, 'flutter@test.com');
      await tester.enterText(passwordFormField, 'Test123');
      await tester.pumpAndSettle();

      await tester.tap(logginButton);
      await Future.delayed(Duration(seconds: 10));
      await tester.pumpAndSettle();

      //navigate to add_page
      final addCustomerButton = find.byType(FloatingActionButton);
      await tester.tap(addCustomerButton);
      await tester.pumpAndSettle();
      //add customer form
      final nameField = find.byType(TextFormField).at(0);
      final phoneField = find.byType(TextFormField).at(1);
      final addressField = find.byType(TextFormField).at(2);
      final cityField = find.byType(TextFormField).at(3);
      final timeField = find.byKey(Key("TimeKey"));
      final dateField = find
          .byKey(Key("DateKey")); // Drugie wystąpienie TextField w formularzu
      final notesField =
          find.byType(TextFormField).last; // Ostatnie wystąpienie TextFormField
      final addButton = find.text('Add Product');
      final saveButton = find.text('Save');
      final productNameField = find.byKey(Key('ProductKey'));
      final quantityField = find.byKey(Key('QtyKey'));
      final priceField = find.byKey(Key('PriceKey'));

      // customer personal information
      await tester.enterText(nameField, 'Jan Kowalski');
      await tester.enterText(phoneField, '123456789');
      await tester.enterText(addressField, 'Ulica Kwiatowa 12');
      await tester.enterText(cityField, '80-174 Gdańsk');
      await tester.enterText(timeField, '14:00');
      await tester.enterText(dateField, '2024-03-13');
      await tester.pumpAndSettle();

      //product information
      await tester.tap(addButton);
      await Future.delayed(Duration(seconds: 5));

      await tester.pumpAndSettle();
      await tester.enterText(productNameField, 'Produkt X'); //product name
      await tester.enterText(quantityField, '2'); // q
      await tester.enterText(priceField, '50'); // piece price
      await tester.pumpAndSettle();

      final gesture =
          await tester.startGesture(Offset(0, 300)); // Start point of the swipe
      await gesture.moveBy(
          Offset(0, -600)); // Move by negative y-axis value to scroll down
      await Future.delayed(Duration(seconds: 5));

      await tester.pumpAndSettle(); // Wait for the animations to settle

      //customer notes
      await tester.enterText(notesField, 'Uwagi dotyczące klienta');
      await tester.pumpAndSettle();

      //save
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await Future.delayed(Duration(seconds: 5));

      await tester.pumpAndSettle();

      //flutter@test.com
      //Test123
    });
  });
}
