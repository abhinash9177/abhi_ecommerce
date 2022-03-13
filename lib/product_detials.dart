import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:abhi_ecommerce/myproviders/cart_symbol.dart';
import 'package:abhi_ecommerce/myproviders/show_cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({Key? key, required this.productId})
      : super(key: key);
  final String productId;
  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AthenticationService>(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShowCartPage()),
                );
              },
              child: const CartSymbolPage()),
        ],
        title: const Text('Product Detials'),
      ),
      body: FutureBuilder<Product?>(
          future: Provider.of<UserProducts>(context)
              .getSingleCartProduct(widget.productId),
          builder: (context, snapshot) {
            final String authuser = auth.currentUserUid!.uid;
            if (snapshot.hasData) {
              return singleProductShow(snapshot.data, authuser);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Card singleProductShow(Product? single, String authuser) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(55.0),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(55.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20), // Image border
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(95), // Image radius
                    child: Image.network(single!.imgUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            Card(
                child: SizedBox(
                    height: 50,
                    child: Center(
                        child: Text(
                      single.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )))),
            Card(
                child: SizedBox(
                    height: 50,
                    child: Center(
                        child: Text(
                      'Price:  ₹.${single.price.toString()}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )))),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  Provider.of<UserProducts>(context, listen: false)
                      .addToCart(authuser, single.id, single.name);
                },
                child: const SizedBox(
                  height: 30,
                  width: 100,
                  child: Center(
                    child: Text('Add To Cart'),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
