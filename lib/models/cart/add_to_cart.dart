import 'dart:convert';

String addToCartToJson(AddToCart data) => json.encode(data.toJson());

class AddToCart {
    String cartItem;
    int quantity;
    String size;

    AddToCart({
        required this.cartItem,
        required this.quantity,
        required this.size,
    });

    Map<String, dynamic> toJson() => {
        "cartItem": cartItem,
        "quantity": quantity,
        "size": size,
    };
}
