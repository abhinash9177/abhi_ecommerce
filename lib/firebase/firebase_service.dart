import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:abhi_ecommerce/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUserDataStore {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  createUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc('testUser').set({
        'firstName': 'John',
        'lastName': 'Peter',
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<List<Product>> getAllProducts() => FirebaseFirestore.instance
      .collection('products')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList());

  Future<void> addProducts() async {
    try {
      var addUserData = FirebaseFirestore.instance.collection('products').doc();
      final products = Product(
          id: addUserData.id,
          name: 'Tables',
          price: 500,
          imgUrl:
              'https://png.pngtree.com/png-vector/20190508/ourmid/pngtree-solid-wooden-tables-and-tables-png-image_904358.jpg',
          category: 'furniture',
          isavalable: true);
      final json = products.toJson();

      await addUserData.set(json);
    } catch (e) {
      print(e);
    }
  }
}
