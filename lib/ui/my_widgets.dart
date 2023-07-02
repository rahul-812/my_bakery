import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_bakery/colors.dart';

import '../backend/cloud_storage.dart';

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

class MakeProductSheet extends StatelessWidget {
  const MakeProductSheet({
    super.key,
    required this.product,
    this.padding = 25.0,
  });

  final double padding;
  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final batchController = TextEditingController(text: '1');

    final requirements = product.requirements.entries;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        0.0,
        25.0,
        0.0,
        MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              product.name,
              style: textTheme.bodyLarge?.copyWith(fontSize: 22.0),
            ),
          ),
          const SizedBox(height: 6.0),
          Center(
            child: Wrap(
              spacing: 3.5,
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Product stock',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(width: 11.0),
                SvgPicture.asset('icons/tag.svg'),
                Text(
                  '46',
                  style: textTheme.bodyLarge?.copyWith(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Batches',
                  style: textTheme.bodyMedium?.copyWith(fontSize: 11.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 11.0),
            child: Text(
              "Today's production",
              style: textTheme.bodyLarge?.copyWith(fontSize: 13.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    onChanged: (text) {},
                    controller: batchController,
                    hint: 'Total batches',
                  ),
                ),
                const SizedBox(width: 14.0),
                const Expanded(child: MyTextField(hint: 'Packets')),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 11.0),
            child: Text(
              "Ingredients used",
              style: textTheme.bodyLarge?.copyWith(fontSize: 13.0),
            ),
          ),
          SizedBox(
            height: 90.0,
            child: ListView.separated(
              itemCount: requirements.length,
              padding: EdgeInsets.symmetric(horizontal: padding),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, __) => const SizedBox(width: 16.0),
              itemBuilder: (_, index) => RequirementCard(
                requirements.elementAt(index),
                textTheme: textTheme,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 20),
            child: MaterialButton(
              onPressed: () {},
              disabledColor: const Color(0xFFD8D8D8),
              elevation: 0.0,
              disabledTextColor: Colors.black,
              highlightElevation: 0.0,
              minWidth: double.infinity,
              shape: const StadiumBorder(),
              color: Colors.black87,
              height: 46.0,
              textColor: Colors.white,
              child: const Text('Make Product'),
            ),
          ),
        ],
      ),
    );
  }
}

class RequirementCard extends StatelessWidget {
  const RequirementCard(this.requirement, {super.key, this.textTheme});

  final TextTheme? textTheme;
  final MapEntry<String, dynamic> requirement;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      decoration: BoxDecoration(
        color: LightColors.greyCard,
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_rounded, size: 12.0),
              const SizedBox(width: 5.0),
              Text(
                requirement.key,
                overflow: TextOverflow.fade,
                style: textTheme?.bodyLarge?.copyWith(fontSize: 14.0),
              ),
            ],
          ),
          if (requirement.value != null) ...[
            Row(
              children: [
                Text('Usable', style: textTheme?.bodySmall),
                const Spacer(),
                const Icon(
                  Icons.arrow_downward,
                  size: 13,
                  color: LightColors.warning,
                ),
                Text(
                  '${requirement.value}',
                  style: textTheme?.bodySmall?.copyWith(
                    color: LightColors.warning,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text('KG', style: textTheme?.bodySmall),
              ],
            ),
            Row(
              children: [
                Text('Rate', style: textTheme?.bodySmall),
                const Spacer(),
                const Icon(
                  Icons.currency_rupee,
                  size: 10,
                ),
                Text(
                  '23.00',
                  style: textTheme?.bodySmall?.copyWith(
                    color: LightColors.textMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
