class CartModel {
  String id;
  final String productId;
  final String name;
  final String category;
  final int quantity;

  CartModel({
    this.id = '',
    required this.name,
    required this.productId,
    required this.category,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'productId': productId,
        'category': category,
        'quantity': quantity,
      };

  static CartModel fromJson(Map<String, dynamic> json) => CartModel(
        id: json['id'],
        name: json['name'],
        productId: json['productId'],
        category: json['category'],
        quantity: json['quantity'],
      );
}
