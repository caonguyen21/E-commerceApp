import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../controllers/constants.dart';
import '../shared/appstyle.dart';
import 'mainscreen.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _favBox = Hive.box('fav_box');

  _deleteFav(int key) async {
    await _favBox.delete(key);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> fav = [];
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
    fav = favData.reversed.toList();
    print(favData);
    return Scaffold(
        backgroundColor: const Color(0xFFE2E2E2),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/top_image.png"), fit: BoxFit.fill)),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "My Favorites",
                    style: appstyle(40, Colors.white, FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                    itemCount: fav.length,
                    padding: EdgeInsets.only(top: 100),
                    itemBuilder: (BuildContext context, int index) {
                      final product = fav[index];
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.grey.shade100, boxShadow: [
                              BoxShadow(color: Colors.grey.shade500, spreadRadius: 5, blurRadius: 0.3, offset: Offset(0, 1))
                            ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(12),
                                      child: CachedNetworkImage(
                                        imageUrl: product["imageUrl"],
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12, left: 20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'],
                                            style: appstyle(16, Colors.black, FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            product['category'],
                                            style: appstyle(14, Colors.grey, FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Text(
                                              "${product['price']}",
                                              style: appstyle(18, Colors.black, FontWeight.w600),
                                            ),
                                          ]),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: GestureDetector(
                                    onTap: () {
                                      _deleteFav(product['key']);
                                      ids.removeWhere((element) => element == product['id']);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                                    },
                                    child: Icon(Icons.heart_broken),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
