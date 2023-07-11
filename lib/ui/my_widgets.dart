import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    this.controller,
    this.label,
    this.hintStyle,
    this.validator,
    this.onChanged,
    this.suffix,
    this.prefix,
  });

  final String? label;
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
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*(\.?[0-9]*)$')),
      ],
      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        prefix: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: prefix,
        ),
        suffix: suffix,
      ),
    );
  }
}
