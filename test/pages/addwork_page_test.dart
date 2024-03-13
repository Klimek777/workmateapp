import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:workmateapp/pages/addwork_page.dart';
import 'package:workmateapp/services/firebase_service.dart';

import 'main_page_test.dart';

double calculateTotalSum(List<Service> services) {
  double sum = 0;
  for (var service in services) {
    double price = double.tryParse(service.priceController!.text) ?? 0;
    int quantity = int.tryParse(service.quantityController!.text) ?? 0;
    sum += price * quantity;
  }
  return sum;
}

void main() {
  setUp(() {
    // Zarejestruj FakeFirebaseService jako implementację FirebaseService
    GetIt.instance.registerSingleton<FirebaseService>(FakeFirebaseService());
  });

  tearDown(() {
    GetIt.instance.reset();
  });
  test('Service toString returns correct format', () {
    final service = Service(
      serviceNameController: TextEditingController(text: "Usługa1"),
      quantityController: TextEditingController(text: "2"),
      priceController: TextEditingController(text: "50"),
    );

    expect(service.toString(), "Usługa1x2x50");
  });

  testWidgets('Name field validation test', (WidgetTester tester) async {
    // Uruchom widget w środowisku testowym
    await tester.pumpWidget(MaterialApp(home: AddWrok()));

    // Znajdź pole tekstowe do wpisywania imienia
    final nameField = find
        .byType(TextFormField)
        .at(0); // Zakładając, że to pierwsze TextFormField w formularzu

    // Spróbuj znaleźć przycisk zapisu bez wpisywania tekstu
    await tester.tap(find.text('Save'));
    await tester.pump(); // Rebuilduj widgety po akcji

    // Walidacja powinna być uruchomiona i wyświetlić błąd, więc sprawdźmy, czy jest wyświetlany komunikat o błędzie
    expect(find.byType(ScaffoldMessenger), findsOneWidget);

    // Wprowadź tekst, który spełnia wymagania walidacji
    await tester.enterText(nameField, 'John Doe');
    await tester.tap(find.text('Save'));
    await tester.pump(); // Rebuilduj widgety po akcji

    // Po poprawnym wprowadzeniu danych, komunikat o błędzie nie powinien się wyświetlać
    expect(find.text('Please enter a name'), findsNothing);
  });

  test('calculateTotalSum returns correct total sum', () {
    // Przygotuj dane testowe
    final services = [
      Service(
        serviceNameController: TextEditingController(text: "Usługa1"),
        quantityController: TextEditingController(text: "2"),
        priceController: TextEditingController(text: "50"),
      ),
      Service(
        serviceNameController: TextEditingController(text: "Usługa2"),
        quantityController: TextEditingController(text: "1"),
        priceController: TextEditingController(text: "30"),
      ),
    ];

    // Oczekiwana suma
    final expectedSum = 130.0; // 2 * 50 + 1 * 30

    // Wywołaj funkcję obliczającą sumę
    final actualSum = calculateTotalSum(services);

    // Sprawdź, czy obliczona suma jest poprawna
    expect(actualSum, expectedSum);
  });
}
