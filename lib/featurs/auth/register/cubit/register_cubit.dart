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

  //************* - Test Registration Function - *************\\
  Future testRegister() async {
    // Generate unique email and username for testing
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String testEmail = 'test_$timestamp@amna.com';
    String testUsername = 'testuser_$timestamp';

    await Register(
      fullName: 'Test User $timestamp',
      userName: testUsername,
      Email: testEmail,
      password: 'password123',
      phoneNumber: '+971501234567',
    );
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

    Map<String, dynamic> formDataMap = {
      "FullName": fullName,
      "Username": userName,
      "Email": Email,
      "Password": password,
      "Phonenumber": phoneNumber,
      "IsAdmin": false,
    };

    // Only add image if one was selected
    if (imageFile != null) {
      formDataMap["ImageCover"] = await MultipartFile.fromFile(imageFile!.path);
    }

    FormData formData = FormData.fromMap(formDataMap);

    // Debug: Log what we're sending
    log('Registration Data:');
    log('FullName: $fullName');
    log('Username: $userName');
    log('Email: $Email');
    log('Phone: $phoneNumber');
    log('IsAdmin: false');
    log('Has Image: ${imageFile != null}');
    log('API Endpoint: $baseUrl$registerEndPoint');

    await dio
        .post(
      '$baseUrl$registerEndPoint',
      data: formData,
    )
        .then((value) {
      log('Registration Response Status: ${value.statusCode}');
      log('Registration Response Data: ${value.data}');

      if (value.statusCode == 200) {
        userModel = AuthUser.fromJson(value.data);
        log('Parsed User Model:');
        log('isAuthenticated: ${userModel!.isAuthenticated}');
        log('message: ${userModel!.message}');
        log('id: ${userModel!.id}');

        // For registration, we consider it successful if we get a 200 response
        // The backend might return isAuthenticated: false but still create the user
        if (userModel!.message != null && userModel!.message!.isNotEmpty) {
          emit(RegisteSuccess(message: userModel!.message!));
        } else {
          emit(RegisteSuccess(
              message: 'Registration successful! Please login to continue.'));
        }
      } else {
        // Handle different status codes
        String errorMessage = 'Registration failed';
        if (value.data != null && value.data is Map) {
          errorMessage = value.data['message'] ?? 'Registration failed';
        }
        emit(RegisterFailed(message: errorMessage));
      }
    }).catchError((e) async {
      log('Registration Error: ${e.toString()}');

      String errorMessage = 'Registration failed. Please try again.';

      // Check if it's a DioError to get more specific error info
      if (e is DioException) {
        log('Dio Error Type: ${e.type}');
        log('Dio Error Response: ${e.response?.data}');
        log('Dio Error Status Code: ${e.response?.statusCode}');

        if (e.type == DioExceptionType.connectionError) {
          // Connection error - backend is down
          log('Backend is down, registration failed');
          errorMessage =
              'Unable to connect to server. Please check your internet connection and try again.';
        } else if (e.response?.data != null && e.response?.data is Map) {
          errorMessage = e.response!.data['message'] ?? errorMessage;
        } else if (e.response?.statusCode == 400) {
          errorMessage = 'Email or username already exists';
        } else if (e.response?.statusCode == 500) {
          errorMessage = 'Server error. Please try again later.';
        }
      }

      emit(RegisterFailed(message: errorMessage));
    });
  }
}
