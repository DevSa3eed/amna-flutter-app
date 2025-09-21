import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/extensions/media_values.dart';
import 'package:dr_sami/featurs/auth/register/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/heights/height.dart';
import '../../../core/theme/text_styles/text_styeles.dart';

import 'widgets/register_form.dart';
import 'widgets/register_image.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colours.White,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: IconThemeData(
                color: Colours.LightBlue,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: context.height / 10,
                  ),
                  SelectImage(),
                  Text(
                    config.localization['register'],
                    style: TextStyles.lightBlue26blod,
                  ),
                  SizedBox(
                    height: Constant.h30,
                  ),
                  const RegisterForm(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
