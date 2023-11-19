import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/payment_controller.dart';
import '../../shared/appstyle.dart';
import '../../shared/reusableText.dart';
import '../mainscreen.dart';

class PaymentFailed extends StatelessWidget {
  const PaymentFailed({super.key});

  @override
  Widget build(BuildContext context) {
    var paymentNotifier = Provider.of<PaymentNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            paymentNotifier.setPaymentUrl = '';
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
          child: const Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/No.png",
              color: Colors.red,
            ),
            ReusableText(text: "Payment Failed", style: appstyle(28, Colors.black, FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
