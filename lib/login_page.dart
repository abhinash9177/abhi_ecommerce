import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var _loginProvider = Provider.of<AthenticationService>(context);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Abhi Ecommerce',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 50),
          const Text('Please loggin to continue'),
          const SizedBox(height: 50),
          ElevatedButton(
              onPressed: _loginProvider.signInAsAnonnymously,
              child: const SizedBox(
                height: 30,
                width: 100,
                child: Center(
                  child: Text('Sign In'),
                ),
              )),
        ],
      )),
    );
  }
}
