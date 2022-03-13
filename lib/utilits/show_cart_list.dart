import 'package:abhi_ecommerce/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowCartListPage extends StatefulWidget {
  const ShowCartListPage({Key? key}) : super(key: key);

  @override
  State<ShowCartListPage> createState() => _ShowCartListPageState();
}

class _ShowCartListPageState extends State<ShowCartListPage> {
  List<CartModel> mycart = [];

  Future<List<CartModel>> fetch() async {
    var result = await FirebaseFirestore.instance
        .collection('users')
        .doc('fgdh6pbVAwROYjIj3ACIf3a3YmH2')
        .collection('mycart')
        .get();
    if (result.docs.isEmpty) {
      return [];
    }
    var cartlist = <CartModel>[];
    for (var doc in result.docs) {
      cartlist.add(CartModel.fromJson(doc.data()));
    }
    return cartlist;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CartModel>>(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Text('data');
          }
          return Text('nsdfs');
        });
  }
}
