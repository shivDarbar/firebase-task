import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final bool showBorder;
  final Function(String?) onChanged;
  final Function(String?) onSubmitted;
  final String hintText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.onChanged,
    required this.onSubmitted,
    required this.hintText,
    required this.showBorder,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(15),
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: showBorder ? const BorderSide() : BorderSide.none,
        ),
        filled: true,
      ),
    );
  }
}
