import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultancyDatabase {
  List<Product> consultancylist = [];
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection("products");

  Future<List<Product>> getData(query) async {
    try {
      await collectionRef.get().then((querySnapshot) {
        for (var result in querySnapshot.docs.where((element) {
          final q1 = element['name'].toString().toLowerCase().contains(query);
          final q2 =
              element['category'].toString().toLowerCase().contains(query);
          return q1 || q2;
        })) {
          consultancylist
              .add(Product.fromJson(result.data() as Map<String, dynamic>));
        }
      });
      print(consultancylist);

      return consultancylist;
    } catch (e) {
      print("Error - $e");
      return [];
    }
  }
}
