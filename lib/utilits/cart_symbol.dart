import 'package:abhi_ecommerce/firebase/firebase_service.dart';
import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:abhi_ecommerce/models/cart_model.dart';
import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartSymbolPage extends StatefulWidget {
  const CartSymbolPage({Key? key}) : super(key: key);

  @override
  State<CartSymbolPage> createState() => _CartSymbolPageState();
}

class _CartSymbolPageState extends State<CartSymbolPage> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AthenticationService>(context);
    var products = Provider.of<MyUserDataStore>(context);
    var userAddedProducts = Provider.of<UserProducts>(context);
    return StreamBuilder<List<CartModel>>(
        stream: userAddedProducts.getMyCartProducts(auth.currentUserUid!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const Icon(Icons.shopping_cart_outlined);
            } else {
              final snap = snapshot.data!.length;
              return Center(
                child: Stack(
                  children: [
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 30,
                    ),
                    Positioned(
                        top: -1,
                        right: -10,
                        child: SizedBox(
                          height: 18,
                          child: CircleAvatar(
                              backgroundColor: Colors.red,
                              child: Text(
                                snap.toString(),
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              )),
                        )),
                  ],
                ),
              );
            }
          } else {
            return const Icon(Icons.shopping_cart_outlined);
          }
        });
  }
}
