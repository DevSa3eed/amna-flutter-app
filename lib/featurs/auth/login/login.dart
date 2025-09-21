import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/extensions/media_values.dart';
import 'package:dr_sami/core/heights/height.dart';
import 'package:dr_sami/featurs/auth/login/widgets/login_form.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/config/config.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../../home_screen/widgets/logo.dart';
import '../widgets/goto_text.dart';
import 'cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colours.White,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Colours.LightBlue,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: context.height / 9,
                  ),
                  Logo(bottom: 0.h, width: 250.w),
                  Text(
                    config.localization['login'],
                    style: TextStyles.lightBlue26blod,
                  ),
                  SizedBox(
                    height: Constant.h30,
                  ),
                  const LoginForm(),
                  GotoText(
                      text: config.localization['gotoregister'],
                      route: Routes.eulaRoute),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
