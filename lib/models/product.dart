import 'dart:convert';

class Products {
  final String id;
  final String name;
  final String title;
  final String category;
  final List<String> imageUrl;
  final String oldPrice;
  final List<dynamic> sizes;
  final String price;
  final String description;
  final List<Comment> comments;

  Products({
    required this.id,
    required this.name,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.oldPrice,
    required this.sizes,
    required this.price,
    required this.description,
    required this.comments,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json["_id"],
      name: json["name"],
      title: json["title"],
      category: json["category"],
      imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
      oldPrice: json["oldPrice"],
      sizes: List<dynamic>.from(json["sizes"].map((x) => x)),
      comments: (json['comments'] as List<dynamic>?)?.map((commentJson) {
            return Comment.fromJson(commentJson ?? {});
          }).toList() ??
          [],
      price: json["price"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "title": title,
        "category": category,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "oldPrice": oldPrice,
        "sizes": List<dynamic>.from(sizes.map((x) => x.toJson())),
        "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
        "price": price,
        "description": description,
      };
}

class Size {
  final String size;
  final bool isSelected;
  final String id;

  Size({
    required this.size,
    required this.isSelected,
    required this.id,
  });

  factory Size.fromJson(Map<String, dynamic> json) => Size(
        size: json["size"],
        isSelected: json["isSelected"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "size": size,
        "isSelected": isSelected,
        "_id": id,
      };
}

class Comment {
  final String userId;
  final String text;
  late Future<String> username; // Use late for non-nullable field
  late DateTime createdAt; // Add this line to handle createdAt

  Comment({
    required this.userId,
    required this.text,
    required this.createdAt,
  }) {
    // Initialize the Future to fetch the username
    username = fetchUsername();
  }

  Future<String> fetchUsername() async {
    // Implement your logic to fetch the username based on userId
    // You may use an API call, database query, or any other method
    // Return the username as a String
    return userId.toString(); // Replace with your actual logic
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['user'] ?? '',
      text: json['text'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'user': userId,
        'text': text,
        'createdAt': createdAt.toIso8601String(), // Convert DateTime to string
      };
}

List<Products> productsFromJson(String str) => List<Products>.from(json.decode(str).map((x) => Products.fromJson(x)));

String productsToJson(List<Products> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
