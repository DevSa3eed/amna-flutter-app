// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../core/theme/Colors/coluors.dart';

class BackGroung extends StatelessWidget {
  BackGroung({required this.widget, super.key});
  Widget widget;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colours.DarkBlue,
        ),
        // Image.asset(
        //   'assets/pngegg.png',
        //   width: double.infinity,
        //   height: double.infinity,
        //   fit: BoxFit.cover,
        // ),
        widget,
      ],
    );
  }
}
