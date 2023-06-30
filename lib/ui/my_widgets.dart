import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    this.controller,
    required this.label,
    this.validator,
    this.suffix,
    this.prefix,
  });

  final String label;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final Widget? prefix;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      validator: validator,
      style: Theme.of(context).textTheme.bodyLarge,
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefix: prefix,
        suffix: suffix,
      ),
    );
  }
}
