import 'package:abhi_ecommerce/firebase/services.dart';
import 'package:abhi_ecommerce/firebase/user_products.dart';
import 'package:abhi_ecommerce/models/my_model.dart';
import 'package:abhi_ecommerce/product_detials.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplyProduct extends StatefulWidget {
  const DisplyProduct({Key? key, required this.snap}) : super(key: key);

  final Product snap;
  @override
  State<DisplyProduct> createState() => _DisplyProductState();
}

class _DisplyProductState extends State<DisplyProduct> {
  @override
  Widget build(BuildContext context) {
    String authenticateduser =
        Provider.of<AthenticationService>(context, listen: false)
            .currentUserUid!
            .uid;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetailsPage(productId: widget.snap.id)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  SizedBox(
                      height: 20, child: Text(widget.snap.price.toString())),
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
      ),
    );
  }
}
