import 'package:dr_sami/core/assets_getter/asset.dart';
import 'package:flutter/material.dart';

class AssetsGetter {
  static GetImage(
      {required String imageUrI,
      double? imageWidth,
      double? imageHeghit,
      Color? color,
      BoxFit? boxFit}) {
    switch (imageUrI) {
      case Assets.logo:
        return Image.asset(
          Assets.logo,
          width: imageWidth,
          height: imageHeghit,
          fit: boxFit,
          color: color,
        );
      case Assets.clinic:
        return Image.asset(
          Assets.clinic,
          width: imageWidth,
          height: imageHeghit,
          fit: boxFit,
          color: color,
        );

      default:
        return Image.asset(
          Assets.logo,
          width: imageWidth,
          height: imageHeghit,
        );
    }
  }
}
