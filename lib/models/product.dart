import 'dart:convert';

List<Product> productsFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

class Product {
  final String id;
  final String name;
  final String category;
  final List<String> imageUrl;
  final String oldPrice;
  final List<Size> sizes;
  final String price;
  final String description;
  final String title;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.oldPrice,
    required this.sizes,
    required this.price,
    required this.description,
    required this.title,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    List<dynamic> sizeList = json['sizes'] ?? [];
    List<Size> sizes =
        sizeList.map((sizeJson) => Size.fromJson(sizeJson)).toList();

    return Product(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      category: json['category'] ?? "",
      imageUrl: (json['imageUrl'] as List<dynamic>).cast<String>(),
      oldPrice: json['oldPrice'] ?? "",
      sizes: sizes,
      price: json['price'] ?? "",
      description: json['description'] ?? "",
      title: json['title'] ?? "",
    );
  }
}

class Size {
  final String size;
  final bool isSelected;

  Size({
    required this.size,
    required this.isSelected,
  });

  factory Size.fromJson(Map<String, dynamic> json) {
    return Size(
      size: json['size'] ?? "",
      isSelected: json['isSelected'] ?? false,
    );
  }
}
