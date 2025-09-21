import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dr_sami/network/local/cache_helper.dart';
import 'package:flutter/material.dart';

import '../../../constants/cached_constants/cached_constants.dart';
import '../config.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(LocalizationInitial());
  Future<void> changeLanguage(bool isArabic) async {
    await cacheHelper.SaveData(key: 'lang', value: isArabic);
    lang = cacheHelper.getData('lang');
    log(lang.toString());
    await config.LoadLanguage(lang!);
    emit(Success(lang!));
  }

  void logOut() async {
    Future.wait([
      cacheHelper.removeData('isAdmin'),
      cacheHelper.removeData('userID'),
      cacheHelper.removeData('token'),
      cacheHelper.removeData('name'),
      cacheHelper.removeData('email'),
      cacheHelper.removeData('image'),
    ]);
    userID = null;
    token = null;
    isAdmin = false;
    userEmail = null;
    name = null;
    image = null;

    emit(LogOut());
  }
}
