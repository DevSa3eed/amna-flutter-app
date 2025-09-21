import 'package:flutter/material.dart';

Widget Logo({top, bottom, width}) {
  return Column(
    children: [
      SizedBox(
        height: top,
      ),
      Image.asset(
        'assets/images/logo.png',
        width: width,
      ),
      SizedBox(
        height: bottom,
      ),
    ],
  );
}
