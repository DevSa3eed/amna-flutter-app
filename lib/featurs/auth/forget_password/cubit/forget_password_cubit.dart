import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constants/api_constants/api_constant.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());
  ForgetPasswordCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();
  //**************************** - Send Emial - ****************************

  void sendEmail({required email}) {
    emit(SendEmailLoading());
    dio
        .post(
      '${baseUrl}Email/Send Email/$email',
    )
        .then((value) {
      if (value.statusCode == 200) {
        emit(SendEmailSuccess(message: 'OTP send Successfully'));
      } else {
        emit(SendEmailFailure(message: 'Try Again OTP send failed'));
      }
    }).catchError((onError) {
      log('******************************************');
      log(onError);
      emit(SendEmailFailure(message: 'Try Again OTP send failed'));
    });
  }

  //**************************** - Send OTP - ****************************
  void sendOTP({
    required otp,
  }) {
    emit(SendOTPLoading());
    dio
        .get(
      '${baseUrl}Email/Send Confirmation Email/$otp',
    )
        .then((value) {
      var data = value.data;
      if (value.statusCode == 200) {
        // Verify Successfully...
        if (data['message'] == 'Verify Successfully...') {
          emit(SendOTPSuccess(message: 'Verify Successfully'));
        } else {
          emit(SendOTPFailure(message: 'Try Again OTP isn`t true'));
        }
      }
    }).catchError((onError) {
      log('******************************************');
      log(onError);
      emit(SendOTPFailure(message: 'Try Again OTP isn`t true'));
    });
  }

  //**************************** - Reset Password - ****************************

  void RestPass({required email, required password, required newpassword}) {
    emit(RestPassLoading());
    FormData data = FormData.fromMap({
      'Email': email,
      'NewPassword': password,
      'ConfirmPassword': newpassword,
    });
    dio.post('${baseUrl}Email/ResetPassword', data: data).then((v) {
      var data = v.data;
      if (v.statusCode == 200) {
        if (data['message'] == 'Changed Successfully...') {
          emit(RestPassSuccess(message: 'Changed Successfully...'));
        } else {
          emit(RestPassFailure(message: 'Try Again'));
        }
      }
    }).catchError((onError) {
      log('******************************************');
      log(onError);
      emit(RestPassFailure(message: 'Try Again'));
    });
  }
}
