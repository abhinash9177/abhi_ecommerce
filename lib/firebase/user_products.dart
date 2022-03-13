import 'package:abhi_ecommerce/models/cart_model.dart';
import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProducts {
  Future<void> addToCart(useruid, productId, productname) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .collection('mycart')
        .where('productId', isEqualTo: productId)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        try {
          var addcartData = FirebaseFirestore.instance
              .collection('users')
              .doc(useruid)
              .collection('mycart')
              .doc(productId);
          final products = CartModel(
              id: addcartData.id,
              name: productname,
              productId: productId,
              category: 'electronics',
              quantity: 1);
          final json = products.toJson();

          addcartData.set(json);
        } catch (e) {
          print(e);
        }
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(useruid)
            .collection('mycart')
            .doc(productId)
            .update({"quantity": FieldValue.increment(1)});
      }
      return;
    });

    //  final checksnap = await checkcartproduct;
  }

  Future<void> quanitiychange(
      {required String useruid,
      required String productid,
      required int change}) async {
    print('my uid is $useruid');
    print('my product is $productid');
    FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .collection('mycart')
        .doc(productid)
        .update({"quantity": FieldValue.increment(change)});
  }

  Future<void> deleteCartItem({
    required String useruid,
    required String productid,
  }) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .collection('mycart')
        .doc(productid)
        .delete();
  }

  Future<void> addToFavourites(useruid, productId) async {
    print('favourite add fav id is: $useruid');
    print('favourite add fav id is: $productId');
    try {
      final getSingle = FirebaseFirestore.instance
          .collection('users')
          .doc(useruid)
          .collection('favourites')
          .doc(productId);
      final snapshot = await getSingle.get();
      if (snapshot.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(useruid)
            .collection('favourites')
            .doc(productId)
            .delete();
      } else {
        //try
        try {
          var addcartData = FirebaseFirestore.instance
              .collection('users')
              .doc(useruid)
              .collection('favourites')
              .doc(productId);
          final products = CartModel(
              id: addcartData.id,
              name: 'google',
              productId: productId,
              category: 'electronics',
              quantity: 1);
          final json = products.toJson();

          await addcartData.set(json);
        } catch (e) {
          print(e);
        } //try
      }
    } catch (e) {
      // TODO
    }
  }

  Future<bool?> getUserFavourite(String useruid, String productId) async {
    print('favourite usre id is: $useruid');
    print('favourite priduct id is: $productId');
    final getSingle = FirebaseFirestore.instance
        .collection('users')
        .doc(useruid)
        .collection('favourites')
        .doc(productId);
    final snapshot = await getSingle.get();
    if (snapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Stream<List<CartModel>> getMyCartProducts(String currentUserUid) {
    print('checking userid : $currentUserUid');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .collection('mycart')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<CartModel>> getMyFavourites(String currentUserUid) {
    print('checking userid : $currentUserUid');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .collection('favourites')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CartModel.fromJson(doc.data()))
            .toList());
  }

  Future<Product?> getSingleCartProduct(String productId) async {
    print('passed id is: $productId');
    final getSingle =
        FirebaseFirestore.instance.collection('products').doc(productId);
    final snapshot = await getSingle.get();
    if (snapshot.exists) {
      return Product.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  }
}
