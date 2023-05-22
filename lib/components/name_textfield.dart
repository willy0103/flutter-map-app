import 'package:flutter/material.dart';

class nameTextField extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const nameTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.abc,
                color: Color.fromARGB(255, 124, 228, 223)),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}

class nameTextField1 extends StatelessWidget {
  final TextEditingController controller;
  final String initialValue;
  final bool obscureText;

  const nameTextField1({
    super.key,
    required this.controller,
    required this.initialValue,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: controller..text = initialValue,
        obscureText: obscureText,
        decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.abc,
              color: Color.fromARGB(255, 124, 228, 223),
              size: 45,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: "",
            hintStyle: TextStyle(color: Colors.grey[500])),
      ),
    );
  }
}
