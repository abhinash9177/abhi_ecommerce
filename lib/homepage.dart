import 'package:abhi_ecommerce/my_account.dart';
import 'package:abhi_ecommerce/myproviders/cart_symbol.dart';
import 'package:abhi_ecommerce/myproviders/my_favourites.dart';
import 'package:abhi_ecommerce/product_detials.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:abhi_ecommerce/firebase/firebase_service.dart';
import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:abhi_ecommerce/login_page.dart';
import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:abhi_ecommerce/myproviders/show_cart.dart';
import 'package:abhi_ecommerce/myproviders/user_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AthenticationService>(context);
    var products = Provider.of<MyUserDataStore>(context);
    var userAddedProducts = Provider.of<UserProducts>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyAccountPage()),
              );
            },
            icon: const Icon(
              Icons.account_circle_outlined,
              size: 28,
            )),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavouritesPage()),
                );
              },
              icon: const Icon(Icons.favorite_border_rounded)),
          InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ShowCartPage()),
                );
              },
              child: const CartSymbolPage()),
          const SizedBox(
            width: 8,
          )
        ],
        title: const Text('Abhi Ecommerce'),
      ),
      body: StreamBuilder<List<Product>>(
          stream: products.getAllProducts(),
          builder: (context, snapshot) {
            String useruid = auth.currentUserUid!.uid;
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('NO Products Available'),
                );
              } else {
                final snap = snapshot.data!;
                return viewData(snap, useruid, userAddedProducts);
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
      floatingActionButton: FLoatingButtons(products: products),
    );
  }

  ListView viewData(List<Product> snap, useruid, userAddedProducts) {
    return ListView.builder(
        itemCount: snap.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SizedBox(
                height: 80,
                child: Stack(
                  children: [
                    DisplyProduct(
                      snap: snap[index],
                      ueruid: useruid,
                    ),
                    Positioned(
                      right: 8,
                      top: -2,
                      child: IconButton(
                          onPressed: () {
                            userAddedProducts.addToFavourites(
                                useruid, snap[index].id);
                          },
                          icon: FavouriteIcon(
                              useruid: useruid, id: snap[index].id)),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class FavouriteIcon extends StatefulWidget {
  const FavouriteIcon({
    Key? key,
    required this.useruid,
    required this.id,
  }) : super(key: key);
  final String useruid;
  final String id;

  @override
  State<FavouriteIcon> createState() => _FavouriteIconState();
}

class _FavouriteIconState extends State<FavouriteIcon> {
  @override
  Widget build(BuildContext context) {
    var userAddedProducts = Provider.of<UserProducts>(context, listen: false);
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.useruid)
          .collection('favourites')
          .doc(widget.id)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const Icon(Icons.favorite_border_outlined);
        }

        if (snapshot.hasData) {
          if (snapshot.data!.exists) {
            return const Icon(Icons.favorite);
          }
          return const Icon(Icons.favorite_outline);
        }

        return const Icon(Icons.favorite_outline);
      },
    );
  }
}

class DisplyProduct extends StatefulWidget {
  const DisplyProduct({Key? key, required this.ueruid, required this.snap})
      : super(key: key);
  final String ueruid;
  final Product snap;
  @override
  State<DisplyProduct> createState() => _DisplyProductState();
}

class _DisplyProductState extends State<DisplyProduct> {
  @override
  Widget build(BuildContext context) {
    var userAddedProducts = Provider.of<UserProducts>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsPage(productId: widget.snap.id)),
        );
        //userAddedProducts.addToCart(widget.ueruid, widget.snap.id);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 100,
              child: Center(child: Image.network(widget.snap.imgUrl))),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 20,
                    child: Text(
                      widget.snap.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 5),
                SizedBox(height: 20, child: Text(widget.snap.price.toString())),
                const SizedBox(height: 10),
                SizedBox(
                    height: 20,
                    child: Text(
                      'Category: ${widget.snap.category}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FLoatingButtons extends StatelessWidget {
  const FLoatingButtons({
    Key? key,
    required this.products,
  }) : super(key: key);

  final MyUserDataStore products;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      onPressed: products.addProducts,
      child: const Icon(Icons.add),
    );
  }
}
