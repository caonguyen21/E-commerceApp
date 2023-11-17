import 'package:flutter/material.dart';
import 'package:flutter_shopping_app/views/shared/appstyle.dart';

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({super.key, this.onPress, required this.buttonColor, required this.label});

  final VoidCallback? onPress;
  final Color buttonColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: buttonColor, style: BorderStyle.solid),
            borderRadius: const BorderRadius.all(Radius.circular(9))),
        child: Center(
          child: Text(
            label,
            style: appstyle(18, buttonColor, FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
