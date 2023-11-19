import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shopping_app/models/orders/orders_res.dart';
import 'package:flutter_shopping_app/services/cart_helper.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';
import 'package:flutter_shopping_app/views/shared/reusableText.dart';

class ProcessOrders extends StatefulWidget {
  const ProcessOrders({Key? key}) : super(key: key);

  @override
  _ProcessOrdersState createState() => _ProcessOrdersState();
}

class _ProcessOrdersState extends State<ProcessOrders> {
  Future<List<PaidOrders>>? _ordersList;

  @override
  void initState() {
    _ordersList = CartHelper().getOrder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E2E2),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Stack(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My Orders",
                      style: appstyle(40, Colors.black, FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 500.h,
                child: FutureBuilder(
                  future: _ordersList,
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
                          'No items in orders.',
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
                          return ProductItem(
                            data: data,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final PaidOrders data;

  const ProductItem({
    Key? key,
    required this.data,
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
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                spreadRadius: 5,
                blurRadius: 0.3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.network(data.productId.imageUrl[0]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.productId.name,
                          style: appstyle(16, Colors.black, FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: 120,
                          child: Text(
                            data.productId.title,
                            style: appstyle(12, Colors.grey, FontWeight.w600),
                            overflow: TextOverflow.visible,
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${data.productId.price}',
                              style: appstyle(14, Colors.black, FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            ReusableText(
                              text: "x${data.quantity.toString()}",
                              style: appstyle(14, Colors.grey, FontWeight.w600),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: ReusableText(
                        text: data.paymentStatus.toUpperCase(),
                        style: appstyle(12, Colors.white, FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.fire_truck_rounded,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        ReusableText(
                          text: data.deliveryStatus.toUpperCase(),
                          style: appstyle(12, Colors.black, FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
