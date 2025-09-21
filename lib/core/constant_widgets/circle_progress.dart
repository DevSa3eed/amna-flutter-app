import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/Colors/coluors.dart';

Widget customLoader(){
  return Center(
    child: CupertinoActivityIndicator(color: Colours.DarkBlue,
      radius: 13.r,
      )
  );
}
///CircularProgressIndicator(
//       color: Colours.DarkBlue,
//       backgroundColor: Colours.White,
//     ),
