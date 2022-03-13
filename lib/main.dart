import 'package:abhi_ecommerce/authentication_page.dart';
import 'package:abhi_ecommerce/firebase/firebase_service.dart';
import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AthenticationService>(
            create: (_) => AthenticationService(FirebaseAuth.instance)),
        Provider<MyUserDataStore>(create: (_) => MyUserDataStore()),
        Provider<UserProducts>(create: (_) => UserProducts()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Abhi Ecommerce',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthenticationPage(),
      ),
    );
  }
}
