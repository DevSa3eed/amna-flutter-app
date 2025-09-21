import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/forget_password/cubit/forget_password_cubit.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../core/config/config.dart';
import '../widgets/custom_Button.dart';

class Otp extends StatelessWidget {
  const Otp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(),
      child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is SendOTPSuccess) {
            showToast(content: state.message);
            Navigator.pushReplacementNamed(context, Routes.changePassword);
          } else if (state is SendOTPFailure) {
            showToast(content: state.message);
          }
        },
        builder: (context, state) {
          final GlobalKey<FormState> OtpFormKey = GlobalKey<FormState>();

          var cubit = ForgetPasswordCubit().get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                config.localization['BTverify'],
                style: TextStyles.lightBlue20blod,
              ),
            ),
            backgroundColor: Colours.White,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Image.asset(
                    'assets/images/otp.png',
                    width: 230.w,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    config.localization['verifititle'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Form(
                    key: OtpFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Pinput(
                          defaultPinTheme: PinTheme(
                            width: 40.w,
                            height: 40.h,
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Colours.DarkBlue,
                                fontWeight: FontWeight.w600),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colours.DarkBlue,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          length: 6,
                          onCompleted: (pin) {
                            if (OtpFormKey.currentState?.validate() ?? false) {
                              cubit.sendOTP(
                                otp: pin,
                              );
                            }
                          },
                          validator: (pin) {
                            if (pin == null || pin.isEmpty) {
                              return 'Please enter the OTP';
                            } else if (pin.length < 6) {
                              return 'OTP must be 6 digits';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 26.h,
                        ),
                        CustomBotton(
                          navigate_fun: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ResetPassword(),
                            //   ),
                            // );
                          },
                          lable: config.localization['BTverify'],
                          fontSize: 20.sp,
                        ),
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
