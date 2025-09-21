import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/forget_password/cubit/forget_password_cubit.dart';
import 'package:dr_sami/featurs/auth/forget_password/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/config/config.dart';
import '../widgets/custom_Button.dart';
import '../widgets/textField.dart';

class ConfirmEmail extends StatelessWidget {
  ConfirmEmail({super.key});
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _emailConfirmFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is SendEmailSuccess) {
            showToast(content: state.message);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Otp()),
            );
          } else if (state is SendEmailFailure) {
            showToast(content: state.message);
          }
        },
        builder: (context, state) {
          var cubit = ForgetPasswordCubit().get(context);
          return Scaffold(
            backgroundColor: Colours.White,
            appBar: AppBar(
              title: Text(
                config.localization['titleBTconfirm'],
                style: TextStyles.lightBlue20blod,
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/confirmEmail.png',
                      width: 300.w,
                      height: 300.h,
                    ),
                    Form(
                      key: _emailConfirmFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFeild(
                            controller: emailController,
                            label: config.localization['email'],
                            isPassword: false,
                            iconPre: Icons.account_circle_outlined,
                            type: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          state is SendEmailLoading
                              ? CircularProgressIndicator(
                                  color: Colours.DarkBlue,
                                  backgroundColor: Colours.DarkBlue,
                                )
                              : CustomBotton(
                                  navigate_fun: () {
                                    if (_emailConfirmFormKey.currentState!
                                        .validate()) {
                                      cubit.sendEmail(
                                          email: emailController.text);
                                    }
                                  },
                                  lable: config.localization['titleBTconfirm'],
                                  fontSize: 18.sp,
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
