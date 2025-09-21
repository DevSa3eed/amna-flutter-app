import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/forget_password/cubit/forget_password_cubit.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/config/config.dart';
import '../widgets/custom_button.dart';
import '../widgets/textField.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> setFormKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmcontroller = TextEditingController();
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is RestPassSuccess) {
            showToast(content: state.message);
            Navigator.pushReplacementNamed(context, Routes.loginRoute);
          } else if (state is RestPassFailure) {
            showToast(content: state.message);
          }
        },
        builder: (context, state) {
          var cubit = ForgetPasswordCubit().get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                config.localization['resetTitile'],
                style: TextStyles.lightBlue20blod,
              ),
            ),
            backgroundColor: Colours.White,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Image.asset(
                    'assets/images/changePassword.png',
                    width: 230.w,
                  ),
                  Form(
                    key: setFormKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        CustomTextFeild(
                          controller: emailController,
                          label: config.localization['email'],
                          isPassword: false,
                          iconPre: Icons.account_circle_outlined,
                          type: TextInputType.emailAddress,
                        ),
                        CustomTextFeild(
                          controller: passwordController,
                          label: config.localization['Password'],
                          isPassword: true,
                          iconPre: Icons.lock_open_sharp,
                          type: TextInputType.text,
                        ),
                        CustomTextFeild(
                          controller: confirmcontroller,
                          label: config.localization['TFconfirmPass'],
                          isPassword: true,
                          iconPre: Icons.lock_open_sharp,
                          type: TextInputType.text,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ConditionBuilder(
                          condition: state is RestPassLoading,
                          ifFalse: CustomBotton(
                            navigate_fun: () {
                              if (setFormKey.currentState!.validate()) {
                                cubit.RestPass(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  newpassword: confirmcontroller.text,
                                );
                              }
                            },
                            lable: config.localization['submit'],
                            fontSize: 20.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
