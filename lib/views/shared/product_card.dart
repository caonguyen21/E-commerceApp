import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/controllers/login_provider.dart';
import 'package:flutter_shopping_app/services/fav_helper.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:flutter_shopping_app/views/shared/reusableText.dart';
import 'package:provider/provider.dart';

import '../../models/favorite/add_to_fav.dart';
import '../../models/favorite/get_productsfav.dart';
import '../ui/NonUser.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.price,
    required this.category,
    required this.name,
    required this.image,
    required this.id,
    required this.title,
    required this.oldPrice,
    required this.sizes,
    required this.description,
  }) : super(key: key);

  final String id;
  final String price;
  final String category;
  final String name;
  final String image;
  final String title;
  final String oldPrice;
  final String sizes;
  final String description;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isProductFavorite;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    isProductFavorite = false; // Initialize to false
    loadFavorites();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> loadFavorites() async {
    try {
      List<ProductFav> favorites = await FavoriteHelper().getFavorites();
      if (_isMounted) {
        setState(() {
          isProductFavorite = favorites.any((fav) => fav.favItem.id == widget.id);
        });
      }
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> toggleFavorite() async {
    try {
      if (isProductFavorite) {
        await FavoriteHelper().deleteFavorite(widget.id);
      } else {
        await FavoriteHelper().addFavorite(Favorite(productId: widget.id));
      }
      setState(() {
        isProductFavorite = !isProductFavorite; // Toggle the favorite status
      });
    } catch (e) {
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 0, 20.w, 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        child: Container(
          height: 325.h,
          width: 225.w,
          decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 1, blurRadius: 0.6, offset: Offset(1, 1))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 186.h,
                    decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(widget.image))),
                  ),
                  Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: Consumer<LoginNotifier>(
                      builder: (context, authNotifier, child) {
                        return GestureDetector(
                          onTap: () async {
                            if (authNotifier.login == true) {
                              await toggleFavorite();
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NonUser()));
                            }
                          },
                          child: Icon(
                            isProductFavorite ? Icons.favorite : Icons.favorite_outline,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 100.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.w, top: 6.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: appstyleWithHt(28, Colors.black, FontWeight.bold, 1.1),
                      ),
                      ReusableText(
                        text: widget.category,
                        style: appstyleWithHt(18, Colors.grey, FontWeight.bold, 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(
                      text: widget.price,
                      style: appstyle(28, Colors.black, FontWeight.w600),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 20.w,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
