import '../product.dart';

class ProductFav {
  Products favItem;
  String id;

  ProductFav({
    required this.favItem,
    required this.id,
  });

  factory ProductFav.fromJson(Map<String, dynamic> json) => ProductFav(
        id: json["_id"],
        favItem: Products.fromJson(json["favItem"]),
      );

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "favItem": favItem.toJson(),
    };
  }
}
