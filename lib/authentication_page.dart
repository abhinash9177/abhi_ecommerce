import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/homepage.dart';
import 'package:abhi_ecommerce/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _userAutChange = Provider.of<AthenticationService>(context);

    return StreamBuilder<User?>(
        stream: _userAutChange.authState,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          }
          return const LoginPage();
        });
  }
}
