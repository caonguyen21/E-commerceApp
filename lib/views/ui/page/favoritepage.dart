import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/models/favorite/get_productsfav.dart';
import 'package:flutter_shopping_app/services/fav_helper.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:flutter_shopping_app/views/ui/page/product_page.dart';
import 'package:provider/provider.dart';

import '../../../controllers/login_provider.dart';
import '../../../controllers/product_provider.dart';
import '../../shared/reusableText.dart';
import '../auth/nonuser.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  late Future<List<ProductFav>> _favList;

  @override
  void initState() {
    _favList = FavoriteHelper().getFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authNotifier = Provider.of<LoginNotifier>(context);
    var productProvider = Provider.of<ProductNotifier>(context);
    return authNotifier.login == false
        ? const NonUser()
        : Scaffold(
            backgroundColor: const Color(0xFFE2E2E2),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 45, 0, 0),
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/top_image.png"), fit: BoxFit.fill)),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "My Favorites",
                        style: appstyle(40, Colors.white, FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 115),
                    child: FutureBuilder(
                      future: _favList,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: ReusableText(
                              text: 'Error: ${snapshot.error}',
                              style: appstyle(18, Colors.black, FontWeight.w600),
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text(
                              'No items in favorites.',
                              style: appstyle(28, Colors.black, FontWeight.bold),
                            ),
                          );
                        } else {
                          final favData = snapshot.data!;
                          return ListView.builder(
                            itemCount: favData.length,
                            padding: EdgeInsets.zero,
                            itemBuilder: (BuildContext context, int index) {
                              final data = favData[index];
                              return GestureDetector(
                                onTap: () {
                                  productProvider.productSizes = (data.favItem.sizes).cast<Map<String, dynamic>>();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProductPage(product: data.favItem)),
                                  );
                                },
                                child: ProductItem(
                                  data: data,
                                  onDelete: () async {
                                    await FavoriteHelper().deleteFavorite(data.favItem.id).then((response) {
                                      if (response == true) {
                                        setState(() {
                                          _favList = FavoriteHelper().getFavorites();
                                        });
                                      }
                                    });
                                  },
                                  onFavoriteDeleted: () {},
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class ProductItem extends StatelessWidget {
  final ProductFav data;
  final VoidCallback onDelete;
  final VoidCallback onFavoriteDeleted;

  const ProductItem({
    Key? key,
    required this.data,
    required this.onDelete,
    required this.onFavoriteDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            boxShadow: [BoxShadow(color: Colors.grey.shade500, spreadRadius: 5, blurRadius: 0.3, offset: const Offset(0, 1))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: CachedNetworkImage(
                      imageUrl: data.favItem.imageUrl[0],
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
                          data.favItem.name,
                          style: appstyle(16, Colors.black, FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          data.favItem.category,
                          style: appstyle(14, Colors.grey, FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${data.favItem.price}',
                              style: appstyle(16, Colors.black, FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    onDelete();
                    onFavoriteDeleted();
                  },
                  child: const Icon(Icons.heart_broken),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
