import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
