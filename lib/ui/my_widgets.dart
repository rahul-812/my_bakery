import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.hintStyle,
    this.validator,
    this.onChanged,
    this.suffix,
    this.prefix,
  });

  final String? label;
  final String? hint;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? suffix;
  final Widget? prefix;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      key: key,
      onChanged: onChanged,
      validator: validator,
      style: textTheme.bodyLarge,
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: textTheme.bodySmall?.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
        labelText: label,
        prefix: prefix,
        suffix: suffix,
      ),
    );
  }
}
