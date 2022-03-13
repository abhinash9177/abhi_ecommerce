import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:abhi_ecommerce/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowTotalPrice extends StatefulWidget {
  const ShowTotalPrice({Key? key}) : super(key: key);

  @override
  State<ShowTotalPrice> createState() => _ShowTotalPriceState();
}

class _ShowTotalPriceState extends State<ShowTotalPrice> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AthenticationService>(context);
    var userAddedProducts = Provider.of<UserProducts>(context);
    return StreamBuilder<List<CartModel>>(
      stream: userAddedProducts.getMyCartProducts(auth.currentUserUid!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.isEmpty) {
            return Text('0');
          } else {
            final snap = snapshot.data!;

            return showMyCart(snap);
          }
        } else {
          return Text('0');
        }
      },
    );
  }

  ListView showMyCart(List<CartModel> snap) {
    return ListView.builder(
        itemCount: snap.length,
        itemBuilder: (context, index) {
          int totoalprice = 0;
          for (int i = 0; i <= snap.length; i++) {
            print('my price is: ${snap[index].price}');
            print('my quantity is: ${snap[index].quantity}');
            int pricequantity = snap[index].price * snap[index].quantity;
            totoalprice = totoalprice + pricequantity;
          }
          return Text(
            totoalprice.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          );
        });
  }
}
