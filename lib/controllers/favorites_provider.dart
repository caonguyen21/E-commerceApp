import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class FavoritesNotifier extends ChangeNotifier {
  final _favBox = Hive.box("fav_box");
  List<dynamic> _ids = [];
  List<dynamic> _favorites = [];
  List<dynamic> _fav = [];

  List<dynamic> get ids => _ids;

  setIds(List<dynamic> newIds) {
    _ids = newIds;
  }

  List<dynamic> get favorites => _favorites;

  setFavorites(List<dynamic> newFav) {
    _favorites = newFav;
  }

  List<dynamic> get fav => _fav;

  setFav(List<dynamic> newFav) {
    _fav = newFav;
  }

  void notifyListenersForIds() {
    notifyListeners();
  }

  void notifyListenersForFavorites() {
    notifyListeners();
  }

  void getFavorites() {
    final favData = _favBox.keys.map((key) {
      final item = _favBox.get(key);
      return {"key": key, "id": item['id']};
    }).toList();
    _favorites = favData.toList();
    setIds(_favorites.map((item) => item['id']).toList());
  }

  void getAllFav(){
    final favData = _favBox.keys.map((key) {
      final item = _favBox.get(key);
      return {
        "key": key,
        "id": item['id'],
        "name": item['name'],
        "category": item["category"],
        "price": item["price"],
        "imageUrl": item["imageUrl"],
      };
    }).toList();
    _fav = favData.reversed.toList();
    //print(favData);
  }

  Future<void> createFav(Map<String, dynamic> addFav) async {
    await _favBox.add(addFav);
  }

  Future<void> deleteFav(int key) async {
    await _favBox.delete(key);
  }

}
