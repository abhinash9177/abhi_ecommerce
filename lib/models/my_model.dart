class Product {
  String id;
  final String name;
  final int price;
  final String imgUrl;
  final String category;
  final bool isavalable;

  Product({
    this.id = '',
    required this.name,
    required this.price,
    required this.imgUrl,
    required this.category,
    required this.isavalable,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'imgUrl': imgUrl,
        'category': category,
        'isavalable': isavalable,
      };

  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        imgUrl: json['imgUrl'],
        category: json['category'],
        isavalable: json['isavalable'],
      );
}
