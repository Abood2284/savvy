import 'package:flutter/material.dart';

class TextFieldBuilder extends StatelessWidget {
  TextFieldBuilder({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.icon,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  final String labelText;
  final TextEditingController controller;
  final IconData icon;
  final ValueChanged<String> onChanged;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        icon: Icon(icon),
        // labelStyle: const TextStyle(
        //   color: Colors.grey,
        //   fontSize: 18,
        // ),
      ),
    );
  }
}
