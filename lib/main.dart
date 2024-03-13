// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workmateapp/pages/addwork_page.dart';
import 'package:workmateapp/pages/editwork_page.dart';
import 'package:workmateapp/pages/home_page.dart';
import 'package:workmateapp/pages/login_page.dart';
import 'package:workmateapp/pages/profile_page.dart';
import 'package:workmateapp/pages/register_page.dart';
import 'package:workmateapp/pages/workdetails_page.dart';
import 'package:workmateapp/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton<FirebaseService>(
    FirebaseService(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routes: {
        'login': (context) => LoginPage(),
        'register': (context) => RegisterPage(),
        'home': (context) => HomePage(),
        'add_work': (context) => AddWrok(),
        'profile': (context) => ProfilePage(),
        'details': (context) => WorkDetailsPage(
              name: '',
              address: '',
              sum: '',
              time: '',
              city: '',
              status: '',
              date: '',
              documentId: '',
              phone: '',
              notes: '',
              product: '',
            ),
        'edit': (context) => EditDeatilsPage(
              name: '',
              phone: '',
              address: '',
              city: '',
              time: '',
              date: '',
              product: '',
              notes: '',
              status: '',
            )
      },
      initialRoute: 'login',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
    );
  }
}
