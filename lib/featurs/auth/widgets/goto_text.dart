import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';

// ignore: must_be_immutable
class GotoText extends StatelessWidget {
  GotoText({required this.text, required this.route, super.key});
  String text;
  String route;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          route,
        );
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colours.LightBlue,
          fontSize: 15.sp,
        ),
      ),
    );
  }
}
