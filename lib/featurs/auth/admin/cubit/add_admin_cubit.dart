import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/featurs/auth/profile/model/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_admin_state.dart';

class AddAdminCubit extends Cubit<AddAdminState> {
  AddAdminCubit() : super(AddAdminInitial());
  static AddAdminCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();
  //====================>>> ADD ADMIN <<<====================\\
  UserProfile? userModel;

  Future addAdmin({
    required String username,
  }) async {
    emit(AddAdminLoading());
    await dio.put('${baseUrl}Admin/AddAdmin/$username').then((v) {
      if (v.statusCode == 200) {
        userModel = UserProfile.fromJson(v.data);
        log(v.data.toString());
        emit(AddAdminSuccess(message: '${userModel!.fullName} is Admin Now'));
      }
    }).catchError((e) {
      log(e.toString());
      emit(AddAdminFailed(message: 'Try Later'));
    });
  }
}
