import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.hintStyle,
    this.validator,
    this.suffix,
    this.prefix,
  });

  final String? label;
  final String? hint;
  final TextStyle? hintStyle;
  final String? Function(String?)? validator;
  final Widget? suffix;
  final Widget? prefix;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      key: key,
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

class MakeProductSheet extends StatelessWidget {
  const MakeProductSheet({super.key, this.padding = 25.0});

  final double padding;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        0.0,
        34.0,
        0.0,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Pastry Cake',
              style: textTheme.bodyLarge?.copyWith(fontSize: 22.0),
            ),
          ),
          const SizedBox(height: 10.0),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Product stock',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(width: 14.0),
                const Icon(FontAwesomeIcons.tag, size: 15.0),
              ],
            ),
          ),
          const SizedBox(height: 35.0),
          Text(
            "Today's production",
            style: textTheme.bodyLarge?.copyWith(fontSize: 13.0),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Row(
              children: const [
                Expanded(child: MyTextField(hint: 'Total batches')),
                SizedBox(width: 14.0),
                Expanded(child: MyTextField(hint: 'Packets')),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
