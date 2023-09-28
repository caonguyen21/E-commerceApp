import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:flutter_shopping_app/views/shared/reusableText.dart';
import 'package:flutter_shopping_app/views/ui/favoritepage.dart';
import 'package:provider/provider.dart';

import '../../controllers/favorites_provider.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({super.key, required this.price, required this.category, required this.name, required this.image, required this.id});

  final String id;
  final String price;
  final String category;
  final String name;
  final String image;

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  @override
  Widget build(BuildContext context) {
    var favoritesNotifier = Provider.of<FavoritesNotifier>(context, listen: true);
    favoritesNotifier.getFavorites();
    String originalPrice = widget.price;
    String extractedPrice = originalPrice.split('\$')[1].trim();
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 0, 20.w, 0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        child: Container(
          height: 325.h,
          width: 225.w,
          decoration:
              const BoxDecoration(boxShadow: [BoxShadow(color: Colors.white, spreadRadius: 1, blurRadius: 0.6, offset: Offset(1, 1))]),
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
                      child: Consumer<FavoritesNotifier>(builder: (context, favoritesNotifier, child) {
                        return GestureDetector(
                          onTap: () {
                            if (favoritesNotifier.ids.contains(widget.id)) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage()));
                            } else {
                              favoritesNotifier.createFav({
                                "id": widget.id,
                                "name": widget.name,
                                "category": widget.category,
                                "price": extractedPrice,
                                "imageUrl": widget.image,
                              });
                            }
                            setState(() {});
                          },
                          child:
                              favoritesNotifier.ids.contains(widget.id) ? const Icon(Icons.favorite) : const Icon(Icons.favorite_outline),
                        );
                      })),
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
                      reusableText(
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
                    reusableText(
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
