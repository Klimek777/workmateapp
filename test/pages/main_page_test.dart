import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:workmateapp/pages/addwork_page.dart';
import 'package:workmateapp/pages/main_page.dart';
import 'package:workmateapp/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

class FakeFirebaseService implements FirebaseService {
  @override
  Stream<QuerySnapshot> getWorkForUser(String date) {
    // Tworzymy fałszywą odpowiedź
    var fakeDocSnapshot = FakeQueryDocumentSnapshot();
    var fakeQuerySnapshot = FakeQuerySnapshot([fakeDocSnapshot]);

    return Stream.value(fakeQuerySnapshot);
  }

  @override
  Map? currentUser;

  @override
  // TODO: implement USER_COLLECTION
  String get USER_COLLECTION => throw UnimplementedError();

  @override
  // TODO: implement WORK_COLLECTION
  String get WORK_COLLECTION => throw UnimplementedError();

  @override
  Future<bool> deleteWork(String documentId) {
    // TODO: implement deleteWork
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getAllWorkForUser(int month) async {
    // Symulowane dane, zmień zgodnie z potrzebami
    return {
      'snapshot':
          '100', // Tu nie korzystamy z QuerySnapshot, więc może być null
      'count': month * 10, // Przykładowa logika, aby wynik zależał od miesiąca
    };
  }

  @override
  Future<LatLng> getCoordinatesFromAddress(String address) {
    return Future.value(LatLng(54.352025, 18.646638));
  }

  @override
  String? getDocumentId() {
    // TODO: implement getDocumentId
    throw UnimplementedError();
  }

  @override
  @override
  Future<Map<String, dynamic>> getDoneWorkForUser(int month) async {
    // Symulowane dane
    return {
      'snapshot': '100',
      'count': month * 5, // Zmniejszamy liczbę wykonanych zadań
    };
  }

  @override
  @override
  Future<double> getSumOfAllWorkForUser(int month) async {
    // Symulowane dane
    return month * 1000.0; // Kwota zależna od miesiąca
  }

  @override
  Future<double> getSumOfDoneWorkForUser(int month) async {
    // Symulowane dane
    return month * 500.0; // Mniejsza kwota dla wykonanych zadań
  }

  @override
  Future<Map> getUserData({required String uid}) {
    // TODO: implement getUserData
    throw UnimplementedError();
  }

  @override
  Future<bool> loginUser({required String email, required String password}) {
    // TODO: implement loginUser
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<bool> postWork(
      String name,
      String phone,
      String address,
      String city,
      String time,
      String date,
      String? product,
      String? notes,
      String sum,
      String status) {
    // TODO: implement postWork
    throw UnimplementedError();
  }

  @override
  Future<bool> registerUser(
      {required String name, required String email, required String password}) {
    // TODO: implement registerUser
    throw UnimplementedError();
  }

  @override
  void setDocumentId(String documentId) {
    // TODO: implement setDocumentId
  }

  @override
  Future<bool> updateStatus(String documentId, String newStatus) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }

  @override
  Future<bool> updateWork(
      String documentId,
      String name,
      String phone,
      String address,
      String city,
      String time,
      String date,
      String? product,
      String? notes,
      String sum,
      String status) {
    // TODO: implement updateWork
    throw UnimplementedError();
  }
}

class FakeQueryDocumentSnapshot implements QueryDocumentSnapshot {
  @override
  Map<String, dynamic> data() {
    return {
      "name": "Test Name",
      "date": "2024-03-13",
      "city": "Białogard",
      "address": "Wojska Polskiego 1",
      "notes": "",
      "phone": "600 600 600",
      "product": "[Montazx1x100]",
      "status": "done",
      "sum": "100",
      "time": "09:50",
      "userId": "fakeuserID"
    };
  }

  @override
  operator [](Object field) {
    // TODO: implement []
    throw UnimplementedError();
  }

  @override
  // TODO: implement exists
  bool get exists => throw UnimplementedError();

  @override
  get(Object field) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  // TODO: implement id
  String get id => "FakeImplementedID";

  @override
  // TODO: implement metadata
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  // TODO: implement reference
  DocumentReference<Object?> get reference => throw UnimplementedError();

  // Implementacja pozostałych metod i właściwości QueryDocumentSnapshot...
}

class FakeQuerySnapshot implements QuerySnapshot {
  final List<QueryDocumentSnapshot> _docs;

  FakeQuerySnapshot(this._docs);

  @override
  List<QueryDocumentSnapshot> get docs => _docs;

  @override
  // TODO: implement docChanges
  List<DocumentChange<Object?>> get docChanges => throw UnimplementedError();

  @override
  // TODO: implement metadata
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  // TODO: implement size
  int get size => throw UnimplementedError();

  // Implementacja pozostałych metod i właściwości QuerySnapshot...
}

void main() {
  setUp(() {
    // Zarejestruj FakeFirebaseService jako implementację FirebaseService
    GetIt.instance.registerSingleton<FirebaseService>(FakeFirebaseService());
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets(
      'MainPage wideges loads correctly also based on given data from Firebase',
      (WidgetTester tester) async {
    // Uruchom widget MainPage w testowym drzewie widgetów
    await tester.pumpWidget(MaterialApp(home: MainPage()));

    // Dodaj tu asercje sprawdzające obecność danych na ekranie
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('2024-03-13'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // i tak dalej, w zależności od tego, co chcesz przetestować
  });
  testWidgets('Navigate to AddWorkPage Test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MainPage(),
      routes: {
        'add_work': (context) => AddWrok(), // Definicja trasy 'add_work'
      },
    ));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Add Customer'), findsOneWidget);
  });
}
