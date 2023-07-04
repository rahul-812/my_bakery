import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../backend/cloud_storage.dart';
import '../colors.dart';
import 'my_widgets.dart';

class ProductionPage extends StatefulWidget {
  const ProductionPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductionPage> createState() => _ProductionPageState();
}

class _ProductionPageState extends State<ProductionPage> {
  final batchController = TextEditingController(text: '1');

  late final Iterable<MapEntry<String, dynamic>> _requirements;
  late final List<TextEditingController?> _controllers;

  @override
  void initState() {
    super.initState();
    _requirements = widget.product.requirements.entries;
    _controllers = _requirements.map<TextEditingController?>((entry) {
      return entry.value == null
          ? null
          : TextEditingController(text: '${entry.value}');
    }).toList();
  }

  @override
  void dispose() {
    for (var item in _controllers) {
      item?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Production'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.product.name,
                style: textTheme.bodyLarge?.copyWith(fontSize: 22.0),
              ),
            ),
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
            const SizedBox(height: 35.0),
            Text(
              "Today's production",
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 15.0,
                // color: LightColors.main,
              ),
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                    onChanged: (text) {
                      if (text.isEmpty) {
                        return;
                      }
                      final batch = int.parse(text);
                      final range = _requirements.length;
                      for (int i = 0; i < range; i++) {
                        var controller = _controllers[i];
                        if (controller != null) {
                          controller.text =
                              '${batch * _requirements.elementAt(i).value}';
                        }
                      }
                    },
                    controller: batchController,
                    hint: 'Total batches',
                  ),
                ),
                const SizedBox(width: 14.0),
                const Expanded(child: MyTextField(hint: 'Packets')),
              ],
            ),
            const SizedBox(height: 35.0),
            Text(
              "Ingredients used",
              style: textTheme.bodyLarge?.copyWith(
                fontSize: 15.0,
                // color: LightColors.main,
              ),
            ),
            const SizedBox(height: 12.0),
            SizedBox(
              height: 110.0,
              child: ListView.separated(
                itemCount: _requirements.length,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 16.0),
                itemBuilder: (_, index) => RequirementCard(
                  _requirements.elementAt(index),
                  controller: _controllers[index],
                  textTheme: textTheme,
                ),
              ),
            ),
            const Spacer(),
            MaterialButton(
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
          ],
        ),
      ),
    );
  }
}

class _RequirementTextField extends StatelessWidget {
  const _RequirementTextField({this.controller});

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
      decoration: const InputDecoration(
        isDense: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.all(0.0),
      ),
    );
  }
}

class RequirementCard extends StatelessWidget {
  const RequirementCard(
    this.requirement, {
    super.key,
    this.textTheme,
    this.controller,
  });

  final TextTheme? textTheme;
  final MapEntry<String, dynamic> requirement;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final isIngredient = requirement.value != null;

    return Container(
      width: 180.0,
      decoration: BoxDecoration(
        color: LightColors.greyCard,
        borderRadius: BorderRadius.circular(6.0),
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.blueGrey.shade100),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded, size: 15.0),
                  const SizedBox(width: 5.0),
                  Text(
                    requirement.key,
                    overflow: TextOverflow.fade,
                    style: textTheme?.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          isIngredient
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Used', style: textTheme?.bodyMedium),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_downward,
                      size: 18.0,
                      color: LightColors.warning,
                    ),
                    SizedBox(
                      width: 35.0,
                      child: _RequirementTextField(
                        controller: controller,
                      ),
                    ),
                    Text(
                      'KG',
                      style: textTheme?.bodyMedium?.copyWith(fontSize: 13.0),
                    ),
                  ],
                )
              : const Spacer(),
          Row(
            children: [
              Text('Cost', style: textTheme?.bodyMedium),
              const Spacer(),
              const Icon(
                Icons.currency_rupee,
                size: 15.0,
              ),
              Text(
                '23.00',
                style: textTheme?.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (!isIngredient) const Spacer(),
        ],
      ),
    );
  }
}
