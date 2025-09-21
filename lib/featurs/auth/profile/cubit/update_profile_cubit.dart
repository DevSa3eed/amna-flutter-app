import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants/api_constants/api_constant.dart';

class ProfileInitial extends ProfileState {
  ProfileInitial()
      : super(
          username: '',
          password: '',
          fullName: '',
          email: '',
          phoneNumber: '',
          isAdmin: false,
        );
}

class ProfileState extends Equatable {
  final String fullName;
  final String username;
  final String email;
  final String password;
  final String phoneNumber;
  final bool isAdmin;
  final String? imageCoverPath;

  const ProfileState({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.isAdmin,
    this.imageCoverPath,
  });

  @override
  List<Object?> get props => [
        fullName,
        username,
        email,
        password,
        phoneNumber,
        isAdmin,
        imageCoverPath
      ];

  ProfileState copyWith({
    String? fullName,
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    bool? isAdmin,
    String? imageCoverPath,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isAdmin: isAdmin ?? this.isAdmin,
      imageCoverPath: imageCoverPath ?? this.imageCoverPath,
    );
  }
}

class ProfileUpdating extends ProfileState {
  ProfileUpdating()
      : super(
          fullName: '',
          username: '',
          email: '',
          password: '',
          phoneNumber: '',
          isAdmin: false,
        );
}

class ProfileUpdated extends ProfileState {
  final String message;

  ProfileUpdated({
    required super.fullName,
    required super.username,
    required super.email,
    required super.password,
    required super.phoneNumber,
    required super.isAdmin,
    super.imageCoverPath,
    required this.message,
  });

  @override
  List<Object?> get props => [
        fullName,
        username,
        email,
        password,
        phoneNumber,
        isAdmin,
        imageCoverPath,
        message
      ];
}

class ProfileUpdateError extends ProfileState {
  final String error;

  ProfileUpdateError(this.error)
      : super(
          fullName: '',
          username: '',
          email: '',
          password: '',
          phoneNumber: '',
          isAdmin: false,
        );

  @override
  List<Object?> get props => [error];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fullName = prefs.getString('fullName');
    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    String? phoneNumber = prefs.getString('phoneNumber');
    bool isAdmin = prefs.getBool('isAdmin') ?? false;
    String? imageCoverPath = prefs.getString('imageCoverPath');

    emit(ProfileState(
      fullName: fullName ?? '',
      username: username ?? '',
      email: email ?? '',
      password: password ?? '',
      phoneNumber: phoneNumber ?? '',
      isAdmin: isAdmin,
      imageCoverPath: imageCoverPath,
    ));
  }

  Future<void> saveProfile({
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
    required bool isAdmin,
    String? imageCoverPath,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('fullName', fullName);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setBool('isAdmin', isAdmin);
    if (imageCoverPath != null) {
      await prefs.setString('imageCoverPath', imageCoverPath);
    }
  }

  Future<void> updateProfile({
    required String id,
    required String fullName,
    required String username,
    required String email,
    required String password,
    required String phoneNumber,
    bool isAdmin = false,
    File? imageCover,
  }) async {
    final String url = '${baseUrl}Auth/UpdateSubProfile/$id';

    try {
      emit(ProfileUpdating());
      log('Emitting ProfileUpdating state');

      // Set up the request
      var request = http.MultipartRequest('PUT', Uri.parse(url))
        ..fields['FullName'] = fullName
        ..fields['Username'] = username
        ..fields['Email'] = email
        ..fields['Password'] = password
        ..fields['Phonenumber'] = phoneNumber
        ..fields['IsAdmin'] = isAdmin.toString();

      String? imageCoverPath;
      if (imageCover != null) {
        imageCoverPath = imageCover.path;
        try {
          request.files.add(await http.MultipartFile.fromPath(
            'ImageCover',
            imageCover.path,
            filename: basename(imageCover.path),
          ));
          log('Added image file to request');
        } catch (e) {
          log('Error attaching image file: $e');
          emit(ProfileUpdateError('Error attaching image file: $e'));
          return; // Exit early if image upload fails
        }
      }

      log('Sending request to update profile...');
      var response = await request.send();

      if (response.statusCode == 200) {
        log('Profile update request successful');

        // Save profile locally
        await saveProfile(
          fullName: fullName,
          username: username,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          isAdmin: isAdmin,
          imageCoverPath: imageCoverPath,
        );
        // context.read<UserProfileCubit>().user;
        emit(ProfileUpdated(
          fullName: fullName,
          username: username,
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          isAdmin: isAdmin,
          imageCoverPath: imageCoverPath,
          message: 'Profile updated successfully',
        ));
        log('Emitting ProfileUpdated state');
      } else {
        // Log error details
        log('Failed to update profile. Status code: ${response.statusCode}');
        emit(ProfileUpdateError(
            'Failed to update profile. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      // Catch all unexpected errors
      log('Error updating profile: $e');
      emit(ProfileUpdateError('Error updating profile: $e'));
    }
  }
}
