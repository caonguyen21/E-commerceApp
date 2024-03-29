class Config {
  static const apiUrl = "192.168.206.1:3000";

  //static const apiUrl = "ecommerce-server-2g66.onrender.com";
  static const paymentBaseUrl = "payment-production-7569.up.railway.app";
  static const String loginUrl = "/api/login";
  static const String paymentUrl = "/stripe/create-checkout-session";
  static const String signupUrl = "/api/register";
  static const String getCartUrl = "/api/cart/find";
  static const String addCartUrl = "/api/cart";
  static const String updateCartUrl = "/api/cart/update-quantity";
  static const String getUserUrl = "/api/users/";
  static const String products = "/api/products";
  static const String orders = "/api/orders";
  static const String search = "/api/products/search/";
  static const String addComment = "/api/products/addComment";
  static const String profile = "/api/products/search/";
  static const String addFavoriteUrl = "/api/favorites";
  static const String addOrderUrl = "/api/orders/addOrder";
}
