import 'package:abhi_ecommerce/my_account.dart';
import 'package:abhi_ecommerce/utilits/cart_symbol.dart';
import 'package:abhi_ecommerce/utilits/my_favourites.dart';
import 'package:abhi_ecommerce/search/display_products.dart';
import 'package:abhi_ecommerce/search/favourite_icon.dart';
import 'package:abhi_ecommerce/search/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:abhi_ecommerce/firebase/firebase_service.dart';
import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:abhi_ecommerce/utilits/show_cart.dart';

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
                  MaterialPageRoute(builder: (context) => const SearchPage()),
                );
              },
              icon: const Icon(Icons.search)),
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
                height: 100,
                child: Stack(
                  children: [
                    DisplyProduct(
                      snap: snap[index],
                    ),
                    Positioned(
                      right: 8,
                      top: -2,
                      child: IconButton(
                          onPressed: () {
                            userAddedProducts.addToFavourites(
                                useruid, snap[index].id, snap[index].price);
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
