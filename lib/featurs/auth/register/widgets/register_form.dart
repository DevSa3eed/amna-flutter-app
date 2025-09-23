import 'package:dr_sami/featurs/auth/register/cubit/register_cubit.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/config.dart';
import '../../../../core/constant_widgets/toast.dart';
import '../../../../core/heights/height.dart';
import '../../../../routes/routes.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/goto_text.dart';
import '../../widgets/textField.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController userNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController countryKeyController = TextEditingController();
    countryKeyController.text = '+971';
    var registerKey = GlobalKey<FormState>();
    return Form(
      key: registerKey,
      child: Column(
        children: [
          CustomTextFeild(
            controller: fullNameController,
            label: config.localization['fullname'],
            isPassword: false,
            iconPre: Icons.account_circle,
            type: TextInputType.text,
          ),
          CustomTextFeild(
            controller: userNameController,
            label: config.localization['username'],
            isPassword: false,
            iconPre: Icons.account_circle,
            type: TextInputType.text,
          ),
          CustomTextFeild(
            controller: emailController,
            label: config.localization['email'],
            isPassword: false,
            iconPre: Icons.account_circle,
            type: TextInputType.emailAddress,
          ),
          CustomTextFeild(
            controller: passController,
            label: config.localization['Password'],
            isPassword: true,
            iconPre: Icons.lock,
            type: TextInputType.text,
          ),
          CustomTextFeild(
            controller: phoneController,
            label: config.localization['phone'],
            isPassword: false,
            iconPre: Icons.phone_android,
            type: TextInputType.phone,
          ),
          SizedBox(
            height: Constant.h10,
          ),
          BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
            if (state is RegisteSuccess) {
              showToast(content: state.message);
              // Check if user is authenticated (auto-logged in)
              if (state.message.contains('successful') &&
                  !state.message.contains('login')) {
                // User is auto-logged in, go to home
                Navigator.pushReplacementNamed(context, Routes.homeRoute);
              } else {
                // User needs to login manually, go to login screen
                Navigator.pushReplacementNamed(context, Routes.loginRoute);
              }
            } else if (state is RegisterFailed) {
              showToast(content: state.message);
            }
          }, builder: (context, state) {
            var cubit = RegisterCubit.get(context);
            return ConditionBuilder(
              condition: state is RegisterLoading,
              ifFalse: CustomBotton(
                  navigate_fun: () {
                    if (registerKey.currentState!.validate()) {
                      // return config.localization['empty'];
                      cubit.Register(
                        fullName: fullNameController.text,
                        userName: userNameController.text,
                        Email: emailController.text,
                        password: passController.text,
                        phoneNumber: phoneController.text,
                      );
                    }
                  },
                  lable: config.localization['register'],
                  fontSize: 20.sp),
            );
          }),
          GotoText(
              text: config.localization['toLogin'], route: Routes.loginRoute),
        ],
      ),
    );
  }
}
