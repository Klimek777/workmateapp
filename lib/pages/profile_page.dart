import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/firebase_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double? _deviceHeight, _deviceWidth;
  FirebaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth! * 0.05,
            vertical: _deviceHeight! * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _titleWidget(),
              SizedBox(
                height: 20,
              ),
              _logoutButton(),
            ],
          )),
    );
  }

  Widget _titleWidget() {
    return Center(
      child: Column(
        children: [
          Text(
            'Hello',
            style: TextStyle(
              fontSize: 35,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            _firebaseService!.currentUser!['name'],
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.orange),
          )
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return MaterialButton(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Center(
              child: Text(
            'Logout',
            style: TextStyle(color: Colors.white, fontSize: 30),
          )),
          width: 200,
          height: 100,
        ),
        onPressed: () {
          _firebaseService!.logout();
          Navigator.popAndPushNamed(context, 'login');
        });
  }
}
