class Favorite {
  final String productId;

  Favorite({required this.productId});

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      productId: json['productId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
    };
  }
}
