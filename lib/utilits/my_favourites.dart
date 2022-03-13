import 'package:abhi_ecommerce/firebase/firebase_service.dart';
import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:abhi_ecommerce/models/cart_model.dart';
import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  State<FavouritesPage> createState() => _ShowCartPageState();
}

class _ShowCartPageState extends State<FavouritesPage> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AthenticationService>(context);
    var products = Provider.of<MyUserDataStore>(context);
    var userAddedProducts = Provider.of<UserProducts>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
      ),
      body: StreamBuilder<List<CartModel>>(
          stream: userAddedProducts.getMyFavourites(auth.currentUserUid!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Favourites is empty'),
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
            return singleProductShow(snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Card singleProductShow(Product single) {
    return Card(
        elevation: 6.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Row(
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
                          child:
                              Image.network(single.imgUrl, fit: BoxFit.cover),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 8,
                top: -2,
                child: IconButton(
                    onPressed: () {
                      _removeFav(single.id, single.price);
                    },
                    icon: const Icon(Icons.favorite)),
              ),
            ],
          ),
        ));
  }

  _removeFav(productId, int price) {
    Provider.of<UserProducts>(context, listen: false).addToFavourites(
        Provider.of<AthenticationService>(context, listen: false)
            .currentUserUid!
            .uid,
        productId,
        price);
  }
}
