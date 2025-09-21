import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dr_sami/featurs/auth/login/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../../constants/api_constants/api_constant.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();
  File? imageFile; // This will hold the selected image
  final ImagePicker _picker = ImagePicker();

  //************* - Function to capture an image from the gallary - *************\\

  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      emit(ImageSelectedSuccess());
    } else {
      emit(ImageNotSelected());
    }
  }

  //************* - Function to capture an image from the camera - *************\\
  Future<void> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      emit(ImageSelectedSuccess());
    } else {
      emit(ImageNotSelected());
    }
  }

  //************* - Register Function - *************\\
  AuthUser? userModel;
  Future Register({
    required String fullName,
    required String userName,
    required String Email,
    required String password,
    required String phoneNumber,
    // required File image,
  }) async {
    emit(RegisterLoading());
    FormData formData = FormData.fromMap({
      "FullName": fullName,
      "Username": userName,
      "Email": Email,
      "Password": password,
      "Phonenumber": phoneNumber,
      "IsAdmin": false,
      "ImageCover": await MultipartFile.fromFile(imageFile!.path),
    });

    await dio
        .post(
      '$baseUrl$registerEndPoint',
      data: formData,
    )
        .then((value) {
      if (value.statusCode == 200) {
        userModel = AuthUser.fromJson(value.data);
        if (userModel!.isAuthenticated!) {
          emit(RegisteSuccess(message: userModel!.message!));
        } else {
          emit(RegisterFailed(message: userModel!.message!));
        }
      }
    }).catchError((e) {
      log(e.toString());
      emit(RegisterFailed(message: 'Email or UserName is already registered'));
    });
  }
}
