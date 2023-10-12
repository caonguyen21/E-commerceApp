import 'package:flutter/material.dart';

import 'appstyle.dart';

class CustomField extends StatefulWidget {
  const CustomField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboard,
    this.suffixIcon,
    this.obscureText,
    this.onEditingComplete,
    this.prefixIcon,
    required this.onRefresh,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function()? onEditingComplete;
  final bool? obscureText;
  final VoidCallback onRefresh;

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool isTextEmpty = true;

  @override
  void initState() {
    super.initState();

    // Listen for changes in the text field
    widget.controller.addListener(() {
      setState(() {
        isTextEmpty = widget.controller.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12))),
      child: TextField(
        keyboardType: widget.keyboard,
        obscureText: widget.obscureText ?? false,
        onEditingComplete: widget.onEditingComplete,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon,
          prefixIcon: GestureDetector(
            onTap: () {
              setState(() {
                widget.controller.clear();
                isTextEmpty = true;
              });
              widget.onRefresh();
            },
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                isTextEmpty ? Icons.camera_alt_outlined : Icons.clear,
                color: Colors.black,
              ),
            ),
          ),
          suffixIconColor: Colors.black,
          hintStyle: appstyle(16, Colors.grey, FontWeight.w500),
          contentPadding: EdgeInsets.zero,
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.transparent, width: 0.5),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.transparent, width: 0.5),
          ),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          border: InputBorder.none,
        ),
        controller: widget.controller,
        cursorHeight: 20,
        cursorRadius: const Radius.circular(30),
        cursorColor: Colors.black,
        style: appstyle(14, Colors.black, FontWeight.w500),
        onSubmitted: widget.validator,
      ),
    );
  }
}
