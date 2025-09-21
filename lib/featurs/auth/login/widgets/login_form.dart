import 'package:dr_sami/featurs/auth/login/cubit/login_cubit.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/config.dart';
import '../../../../core/constant_widgets/toast.dart';
import '../../../../core/heights/height.dart';
import '../../../../routes/routes.dart';
import '../../widgets/custom_Button.dart';
import '../../widgets/goto_text.dart';
import '../../widgets/textField.dart';

GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessful) {
          showToast(content: state.message);

          Navigator.pushReplacementNamed(context, Routes.homeRoute);
        } else if (state is LoginFailure) {
          showToast(content: state.message);
        }
      },
      builder: (context, state) {
        var cubit = LoginCubit.get(context);
        return Form(
            key: loginFormKey,
            child: Column(children: [
              CustomTextFeild(
                controller: cubit.emailController,
                label: config.localization['email'],
                isPassword: false,
                iconPre: Icons.account_circle,
                type: TextInputType.emailAddress,
              ),
              CustomTextFeild(
                controller: cubit.passController,
                label: config.localization['Password'],
                isPassword: true,
                iconPre: Icons.lock,
                type: TextInputType.text,
              ),
              GotoText(
                  text: config.localization['forgetPassword'],
                  route: Routes.confirmEmail),
              SizedBox(
                height: Constant.h10,
              ),
              ConditionBuilder(
                condition: state is LoginLoading,
                ifFalse: CustomBotton(
                    navigate_fun: () {
                      if (loginFormKey.currentState!.validate()) {
                        cubit.login(
                          email: cubit.emailController.text,
                          password: cubit.passController.text,
                        );
                      }
                    },
                    lable: config.localization['login'],
                    fontSize: 20.sp),
              )
            ]));
      },
    );
  }
}
