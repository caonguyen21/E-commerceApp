class Product {
  ProductItem cartItem;
  int quantity;
  String id;
  String size; // Change the type of size to int

  Product({
    required this.cartItem,
    required this.quantity,
    required this.id,
    required this.size,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        cartItem: ProductItem.fromJson(json["cartItem"]),
        quantity: json["quantity"],
        id: json["_id"],
        size: json["size"], // Update to include size
      );

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "quantity": quantity,
      "size": size, // Include size in the JSON representation
      "cartItem": cartItem.toJson(),
    };
  }
}

class ProductItem {
  String id;
  String name;
  String category;
  List<String> imageUrl;
  String price;

  ProductItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
  });

  factory ProductItem.fromJson(Map<String, dynamic> json) => ProductItem(
        id: json["_id"],
        name: json["name"],
        category: json["category"],
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        price: json["price"],
      );

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "category": category,
      "imageUrl": imageUrl,
      "price": price,
    };
  }
}
