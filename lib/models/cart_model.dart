class CartModel {
  String id;
  final String productId;
  final String name;
  final String category;
  final int price;
  final int quantity;

  CartModel({
    this.id = '',
    required this.name,
    required this.productId,
    required this.category,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'productId': productId,
        'category': category,
        'price': price,
        'quantity': quantity,
      };

  static CartModel fromJson(Map<String, dynamic> json) => CartModel(
        id: json['id'],
        name: json['name'],
        productId: json['productId'],
        category: json['category'],
        price: json['price'],
        quantity: json['quantity'],
      );
}
