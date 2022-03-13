import 'package:abhi_ecommerce/authentication_page.dart';
import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('You are now logged In'),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Provider.of<AthenticationService>(context, listen: false)
                      .signOut()
                      .then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AuthenticationPage()),
                          ));
                },
                child: const SizedBox(
                  height: 30,
                  width: 100,
                  child: Center(
                    child: Text('Sign Out'),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
