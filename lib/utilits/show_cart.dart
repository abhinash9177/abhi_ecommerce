import 'package:abhi_ecommerce/firebase/firebase_service.dart';
import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:abhi_ecommerce/models/cart_model.dart';
import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowCartPage extends StatefulWidget {
  const ShowCartPage({Key? key}) : super(key: key);

  @override
  State<ShowCartPage> createState() => _ShowCartPageState();
}

class _ShowCartPageState extends State<ShowCartPage> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AthenticationService>(context);
    var products = Provider.of<MyUserDataStore>(context);
    var userAddedProducts = Provider.of<UserProducts>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: StreamBuilder<List<CartModel>>(
          stream: userAddedProducts.getMyCartProducts(auth.currentUserUid!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Cart is empty'),
                );
              } else {
                final snap = snapshot.data!;
                return showMyCart(snap);
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  ListView showMyCart(List<CartModel> snap) {
    return ListView.builder(
        itemCount: snap.length,
        itemBuilder: (context, index) {
          return singleProductCard(snap, index);
        });
  }

  FutureBuilder<Product?> singleProductCard(List<CartModel> snap, int index) {
    return FutureBuilder<Product?>(
        future: Provider.of<UserProducts>(context)
            .getSingleCartProduct(snap[index].productId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return singleProductShow(snapshot.data!, snap[index].quantity);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Card singleProductShow(Product single, int quantity) {
    return Card(
        elevation: 6.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 140,
                width: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Image border
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(95), // Image radius
                      child: Image.network(single.imgUrl, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 50,
                          child: Center(
                              child: Text(
                            single.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ))),
                      const SizedBox(height: 15),
                      SizedBox(
                          height: 50,
                          child: Center(
                              child: Text(
                            'Price:  ₹.${single.price.toString()}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ))),
                      const SizedBox(height: 5),
                      const Text('Quantities'),
                      SizedBox(
                        height: 35,
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Card(
                              elevation: 4.0,
                              child: Center(
                                child: IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      quantity > 1
                                          ? _dncrementQuantity(single.id)
                                          : _deleteProduct(single.id);
                                    },
                                    icon: const Center(
                                        child: Icon(Icons.remove))),
                              ),
                            ),
                            Text(
                              quantity.toString(),
                              style: const TextStyle(fontSize: 20),
                            ),
                            Card(
                              elevation: 4.0,
                              child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    _incrementQuantity(single.id);
                                  },
                                  icon: const Icon(Icons.add)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  _incrementQuantity(productid) {
    Provider.of<UserProducts>(context, listen: false).quanitiychange(
        useruid: Provider.of<AthenticationService>(context, listen: false)
            .currentUserUid!
            .uid,
        productid: productid,
        change: 1);
  }

  _dncrementQuantity(productid) {
    Provider.of<UserProducts>(context, listen: false).quanitiychange(
        useruid: Provider.of<AthenticationService>(context, listen: false)
            .currentUserUid!
            .uid,
        productid: productid,
        change: -1);
  }

  _deleteProduct(productid) {
    Provider.of<UserProducts>(context, listen: false).deleteCartItem(
        useruid: Provider.of<AthenticationService>(context, listen: false)
            .currentUserUid!
            .uid,
        productid: productid);
  }
}
