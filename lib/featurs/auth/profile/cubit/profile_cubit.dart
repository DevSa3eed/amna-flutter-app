import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/featurs/auth/profile/model/user_profile_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../../constants/api_constants/api_constant.dart';
import '../../../../network/local/cache_helper.dart';

part 'profile_state.dart';

File? updateFile; // This will hold the selected image

class UserProfileCubit extends Cubit<userProfileState> {
  UserProfileCubit() : super(ProfileInitial());
  static UserProfileCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();

  final ImagePicker _picker = ImagePicker();

  //************* - Function to capture an image from the gallary - *************\\

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      updateFile = File(pickedFile.path);
      emit(ImageSelectedSuccess());
    } else {
      emit(ImageNotSelected());
    }
  }

  //************* - Function to capture an image from the camera - *************\\
  Future<void> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      updateFile = File(pickedFile.path);
      emit(ImageSelectedSuccess());
    } else {
      emit(ImageNotSelected());
    }
  }

  //=============>>>>>>>>>> User Information <<<<<<<<<<<=============\\
  UserProfile? userModel;
  String? imageCover;

  Future<void> getUserInfo() async {
    emit(GetProfileLoading());

    try {
      final response = await dio.get(
        '$baseUrl$getoneUser',
        queryParameters: {'userId': userID},
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data.isNotEmpty) {
        userModel = UserProfile.fromJson(response.data[0]);
        imageCover = '$imageUrl${response.data[0]['imageCover']}';
        cacheHelper.SaveData(key: 'userID', value: userModel!.id!);
        cacheHelper.SaveData(key: 'isAdmin', value: userModel!.isAdmin!);
        cacheHelper.SaveData(key: 'name', value: userModel!.fullName!);
        cacheHelper.SaveData(key: 'email', value: userModel!.email!);
        cacheHelper.SaveData(key: 'image', value: userModel!.imageCover!);
        cacheHelper.SaveData(key: 'phone', value: userModel!.phoneNumber!);
        // cacheHelper.SaveData(key: 'username', value: userModel!.userName!);
        userID = cacheHelper.getData('userID');
        token = cacheHelper.getData('token');
        isAdmin = cacheHelper.getData('isAdmin');
        name = cacheHelper.getData('name');
        userEmail = cacheHelper.getData('email');
        phone = cacheHelper.getData('phone');
        username = cacheHelper.getData('username');
        image = cacheHelper.getData('image');
        emit(GetProfilesuccess(message: response.data[0]['email']));
      } else {
        log('============>>>Failed to load user data<<<===========');

        emit(GetProfileFailed(message: 'Failed to load user data'));
      }
    } catch (e) {
      log('============>>>Failed to load user data<<<===========');

      log(e.toString());
      emit(GetProfileFailed(message: 'Error: ${e.toString()}'));
    }
  }

  //=============>>>>>>>>>> Logout User  <<<<<<<<<<<=============\\
  void logOut() async {
    Future.wait([
      cacheHelper.removeData('isAdmin'),
      cacheHelper.removeData('userID'),
      cacheHelper.removeData('token'),
      cacheHelper.removeData('name'),
      cacheHelper.removeData('email'),
      cacheHelper.removeData('image'),
      cacheHelper.removeData('username'),
      cacheHelper.removeData('phone'),
    ]);
    userID = null;
    token = null;
    isAdmin = false;
    userEmail = null;
    name = null;
    image = null;
    username = null;
    phone = null;
    emit(LogOut());
  }

  //=============>>>>>>>>>> delete User  <<<<<<<<<<<=============\\
  Future deleteUser() async {
    emit(DeleteProfileLoading());
    await dio.delete('${baseUrl}Admin/Admin/DeleteUser/$userID').then((v) {
      if (v.statusCode == 200) {
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
        emit(DeleteProfilesuccess(message: 'Profile Deleted'));
      }
    }).catchError((e) {
      log(e.toString());
      emit(DeleteProfileFailed(message: 'Sorry Try Again'));
    });
  }
}
