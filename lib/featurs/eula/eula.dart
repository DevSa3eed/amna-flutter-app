import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/config/config.dart';

import '../../core/heights/height.dart';
import '../../core/theme/Colors/coluors.dart';
import '../../core/theme/text_styles/text_styeles.dart';
import 'widgets/check_botton.dart';
import 'widgets/eula_veiw.dart';

class Eula extends StatefulWidget {
  const Eula({super.key});

  @override
  State<Eula> createState() => _EulaState();
}

class _EulaState extends State<Eula> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.White,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Keep background transparent
        title: Text(
          config.localization['EULA'],
          style: TextStyles.lightBlue20blod,
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(15.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ALLEula(),
              SizedBox(
                height: Constant.h30,
              ),
              const CheckBotton(),
            ],
          ),
        ),
      ),
    );
  }
}
