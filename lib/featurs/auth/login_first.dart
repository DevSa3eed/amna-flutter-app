import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/featurs/auth/widgets/custom_button.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/config/config.dart';

class LoginFirst extends StatelessWidget {
  const LoginFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.White,
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(
            'assets/images/login.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const Spacer(flex: 2),
          CustomBotton(
              navigate_fun: () {
                Navigator.pushNamed(context, Routes.loginRoute);
              },
              lable: config.localization['login'],
              fontSize: 20.sp),
          CustomBotton(
              navigate_fun: () {
                Navigator.pushNamed(context, Routes.eulaRoute);
              },
              lable: config.localization['register'],
              fontSize: 20.sp),
          const Spacer(),
        ],
      ),
    );
  }
}
