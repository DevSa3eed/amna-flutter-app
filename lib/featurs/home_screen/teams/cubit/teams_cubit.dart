import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/featurs/home_screen/teams/model/team_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'teams_state.dart';

class TeamsCubit extends Cubit<TeamsState> {
  TeamsCubit() : super(TeamsInitial());
  TeamsCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();

  File? imageFile; // This will hold the selected image
  final ImagePicker _picker = ImagePicker();
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

  List listOfMembers = [];
  //==================>>> Get Team Members <<<================\\
  Future getTeamMembers() async {
    emit(TeamsLoading());
    await dio.get('${baseUrl}Team/GetAllTeams').then((v) {
      if (v.statusCode == 200) {
        List<dynamic> data = v.data;
        List<Map<String, dynamic>> mapList =
            List<Map<String, dynamic>>.from(data);
        listOfMembers =
            mapList.map((json) => TeamMember.fromJson(json)).toList();
        emit(TeamsSuccess());
      }
    }).catchError((e) {
      emit(TeamsFailed());
    });
  }

  //==================>>> Add Team Members <<<================\\
  Future addTeamMembers({
    required String name,
    required String position,
  }) async {
    emit(AddTeamsLoading());
    FormData formData = FormData.fromMap({
      "Titel": name,
      "Position": position,
      "Image": await MultipartFile.fromFile(
        imageFile!.path,
      ),
    });
    await dio.post('${baseUrl}Team/AddMember', data: formData).then((v) {
      if (v.statusCode == 200) {
        emit(AddTeamsSuccess(message: ' Member has been added successfully '));
      }
    }).catchError((e) {
      emit(AddTeamsFailed(
          message: 'Unfortunately, the member has not been added'));
    });
  }

  //==================>>> Update Team Members <<<================\\
  Future updateTeamMembers(String name, String position, int id) async {
    emit(UpdateTeamsLoading());
    FormData formData = FormData.fromMap({
      "Titel": name,
      "Position": position,
      "Image": await MultipartFile.fromFile(
        imageFile!.path,
      ),
    });
    await dio.put(
      '${baseUrl}Team/UpdateTeams',
      data: formData,
      queryParameters: {
        "catID": id,
      },
    ).then((v) {
      if (v.statusCode == 200) {
        emit(UpdateTeamsSuccess(
            message: ' Member has been Updated successfully '));
      }
    }).catchError((e) {
      emit(UpdateTeamsFailed(
          message: 'Unfortunately, the member has not been Updated'));
    });
  }

  //==================>>> Delete Team Members <<<================\\
  Future deleteMember({required int id}) async {
    emit(DeleteTeamsLoading());
    await dio.delete(
      '${baseUrl}Team/DeleteMember',
      queryParameters: {"id": id},
    ).then((v) {
      if (v.statusCode == 200) {
        emit(DeleteTeamsSuccess(
            message: ' Member has been Deleted successfully '));
        emit(TeamsDeletedAndRefresh());
      }
    }).catchError((e) {
      emit(DeleteTeamsFailed(
          message: 'Unfortunately, the member has not been Deleted'));
    });
  }
}
