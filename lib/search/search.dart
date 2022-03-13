import 'dart:async';

import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:abhi_ecommerce/search/display_products.dart';
import 'package:abhi_ecommerce/search/favourite_icon.dart';
import 'package:abhi_ecommerce/search/search_widget.dart';
import 'package:abhi_ecommerce/search/testserver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Product> productsData = [];

  String query = '';
  Timer? debouncer;
  bool loading = true;

  get child => null;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final listAllProducts = await ConsultancyDatabase().getData(query);

    setState(() => productsData = listAllProducts);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                child: buildSearch(),
                height: 75,
              ),
              Expanded(
                child: loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.grey,
                        ),
                      )
                    : ListView.builder(
                        itemCount: productsData.length,
                        itemBuilder: (context, index) {
                          final requestedQueryData = productsData[index];
                          print(requestedQueryData.name.length.toString());
                          return buildBook(requestedQueryData);
                        },
                      ),
              ),
            ],
          ),
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Product or Category',
        onChanged: searchBook,
      );

  Future searchBook(String query) async => debounce(() async {
        final newQueryList = await ConsultancyDatabase().getData(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          productsData = newQueryList;
        });
      });

  Widget buildBook(Product requestedQueryData) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          //color: Colors.pink[50],
          elevation: 6.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 130,
              child: Stack(
                children: [
                  DisplyProduct(
                    snap: requestedQueryData,
                  ),
                  Positioned(
                    right: 8,
                    top: -2,
                    child: IconButton(
                        onPressed: () {
                          _addtoFavouritesButton(
                              requestedQueryData.id, requestedQueryData.price);
                        },
                        icon: FavouriteIcon(
                            useruid: Provider.of<AthenticationService>(context,
                                    listen: false)
                                .currentUserUid!
                                .uid,
                            id: requestedQueryData.id)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  _addtoFavouritesButton(requestedQueryData, int price) {
    Provider.of<UserProducts>(context, listen: false).addToFavourites(
        Provider.of<AthenticationService>(context, listen: false)
            .currentUserUid!
            .uid,
        requestedQueryData,
        price);
  }
}
