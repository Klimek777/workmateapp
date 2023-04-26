import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:workmateapp/services/firebase_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceHeight, _deviceWidth;
  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  String? _name;
  String? _email;
  String? _password;
  @override
  void initState() {
    super.initState();

    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title(),
            _registrationForm(),
            _registerButton(),
            _loginPageLink()
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'WorkMate',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Text(
            'Register',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Name...',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      validator: (_value) => _value!.length > 0 ? null : 'Enter a valid name',
      onSaved: (_value) {
        setState(() {
          _name = _value;
        });
      },
    );
  }

  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "Email...",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      validator: (_value) {
        bool _result = _value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );

        return _result ? null : "Please enter a valid email";
      },
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.orange),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        hintText: "Password...",
      ),
      onSaved: (_value) {
        setState(() {
          _password = _value;
        });
      },
      validator: (_value) => _value!.length > 6
          ? null
          : "Please enter a password greater than 6 characters",
    );
  }

  Widget _registrationForm() {
    return SizedBox(
      height: _deviceHeight! * 0.30,
      width: _deviceWidth! * 0.7,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameTextField(),
            SizedBox(
              height: 10,
            ),
            _emailTextField(),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: _passwordTextField(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: () {
        _registerUser();
      },
      minWidth: _deviceWidth! * 0.70,
      height: _deviceHeight! * 0.06,
      color: Colors.orange,
      child: Text(
        'Register',
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _loginPageLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: GestureDetector(
        child: const Text(
          "Already have an account?",
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w200),
        ),
        onTap: () => Navigator.pop(context, 'login'),
      ),
    );
  }

  void _registerUser() async {
    if (_registerFormKey.currentState!.validate()) {
      _registerFormKey.currentState!.save();
      bool _result = await _firebaseService!.registerUser(
        name: _name!,
        email: _email!,
        password: _password!,
      );
      if (_result) Navigator.pop(context);
    }
  }
}
