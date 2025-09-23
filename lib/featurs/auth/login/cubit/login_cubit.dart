import 'package:dio/dio.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/featurs/auth/login/models/user.dart';
import 'package:dr_sami/network/local/cache_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  //************************** Demo Login **************************\\
  Future demoLogin() async {
    emit(LoginLoading());

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Create mock user data
    userModel = AuthUser(
      id: '1',
      isAdmin: false,
      message: 'Demo login successful',
      isAuthenticated: true,
      username: 'demo_user',
      fullname: 'Demo User',
      email: 'demo@amna.com',
      image: 'assets/images/account.png',
      token: 'demo_token_123456789',
      expiresOn: DateTime.now().add(const Duration(days: 30)).toIso8601String(),
      refreshTokenExpiration:
          DateTime.now().add(const Duration(days: 30)).toIso8601String(),
    );

    // Save mock data to cache
    cacheHelper.SaveData(key: 'userID', value: userModel!.id!);
    cacheHelper.SaveData(key: 'token', value: userModel!.token!);
    cacheHelper.SaveData(key: 'isAdmin', value: userModel!.isAdmin!);
    cacheHelper.SaveData(key: 'name', value: userModel!.fullname!);
    cacheHelper.SaveData(key: 'email', value: userModel!.email!);
    cacheHelper.SaveData(key: 'username', value: userModel!.username!);
    cacheHelper.SaveData(key: 'image', value: userModel!.image!);

    // Update global variables
    userID = cacheHelper.getData('userID');
    token = cacheHelper.getData('token');
    isAdmin = cacheHelper.getData('isAdmin');
    name = cacheHelper.getData('name');
    userEmail = cacheHelper.getData('email');
    username = cacheHelper.getData('username');
    image = cacheHelper.getData('image');

    debugPrint('/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/');
    debugPrint('DEMO LOGIN SUCCESSFUL');
    debugPrint('User ID: ${userModel!.id}');
    debugPrint('Name: ${userModel!.fullname}');
    debugPrint('Email: ${userModel!.email}');
    debugPrint('/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/');

    emit(LoginSuccessful(
        message: 'Demo login successful! Welcome to Amna Telehealth'));
  }

  //************************** Login **************************\\
  AuthUser? userModel;
  Future login({required String email, required String password}) async {
    emit(LoginLoading());

    FormData formData = FormData.fromMap({
      'Email': email,
      'Password': password,
    });
    dio.post('$baseUrl$loginEndPoint', data: formData).then((value) async {
      if (value.statusCode == 200) {
        userModel = AuthUser.fromJson(value.data);
        cacheHelper.SaveData(key: 'userID', value: userModel!.id!);
        cacheHelper.SaveData(key: 'token', value: userModel!.token!);
        cacheHelper.SaveData(key: 'isAdmin', value: userModel!.isAdmin!);
        cacheHelper.SaveData(key: 'name', value: userModel!.fullname!);
        cacheHelper.SaveData(key: 'email', value: userModel!.email!);
        cacheHelper.SaveData(key: 'username', value: userModel!.username!);
        cacheHelper.SaveData(key: 'image', value: userModel!.image!);
        userID = cacheHelper.getData('userID');
        token = cacheHelper.getData('token');
        isAdmin = cacheHelper.getData('isAdmin');
        name = cacheHelper.getData('name');
        userEmail = cacheHelper.getData('email');
        username = cacheHelper.getData('username');
        image = cacheHelper.getData('image');
        debugPrint('/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/');
        debugPrint(cacheHelper.getData('userID'));
        debugPrint(cacheHelper.getData('token'));
        debugPrint(cacheHelper.getData('isAdmin').toString());
        debugPrint('/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/*/');
        emit(LoginSuccessful(message: userModel!.message!));
      } else if (value.statusCode == 400) {
        emit(LoginFailure(message: "Email or Password is incorrect!"));
      }
    }).catchError((onError) {
      // if (onError.toString() == 'Exception: Request failed with status: 400') {
      //   emit(LoginFailure(message: "Email or Password is incorrect!"));
      // } else {
      debugPrint(onError.toString());
      emit(LoginFailure(message: 'Email or Password is incorrect!'));
      // }
    });
  }
}
