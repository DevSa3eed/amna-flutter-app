import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/featurs/home_screen/opinions/model/opinion_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'opinions_state.dart';

class OpinionsCubit extends Cubit<OpinionsState> {
  OpinionsCubit() : super(OpinionsInitial());
  OpinionsCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();

  //===================>>> Get Opinions <<<===================\\
  Opinions? opinionModel;
  List<Opinions> listofOpinion = [];
  Future getOpinions() async {
    emit(GetOpinionsloading());
    await dio.get('${baseUrl}UserReview/GetAllReview').then((v) {
      if (v.statusCode == 200) {
        List<dynamic> data = v.data;
        List<Map<String, dynamic>> mapList =
            List<Map<String, dynamic>>.from(data);
        listofOpinion = mapList.map((json) => Opinions.fromJson(json)).toList();
        emit(
            GetOpinionsSuccess(message: 'All Opinions Retrieved Successfully'));
      } else {
        emit(GetOpinionsFailed(
            message: 'Failed with status code: ${v.statusCode}'));
        debugPrint('Failed: Status code ${v.statusCode}');
      }
    }).catchError((e) {
      emit(GetOpinionsFailed(message: 'Error: ${e.toString()}'));
      log('Error: $e');
    });
  }
  //===================>>> Edite Opinions <<<===================\\

  Future EditOpinions({
    required String title,
    required String description,
    required String userid,
    required int id,
  }) async {
    emit(EditOpinionsloading());
    FormData formData = FormData.fromMap(
        {"Titel": title, "Description": description, "UsersId": userid});
    await dio.put('${baseUrl}UserReview/UpdateReview',
        data: formData,
        queryParameters: {
          "catID": id,
        }).then((v) {
      if (v.statusCode == 200) {
        getOpinions();
        emit(EditOpinionsSuccess(message: 'Your Opinion Edited Successfully'));
      } else {
        emit(EditOpinionsFailed(
            message: 'Failed with status code: ${v.statusCode}'));
        log('Failed: Status code ${v.statusCode}');
      }
    }).catchError((e) {
      emit(EditOpinionsFailed(message: 'Your opinion didn`t Edit Try later'));
      debugPrint('Error: $e');
    });
  }
  //===================>>> Add Opinions <<<===================\\

  Future AddOpinions({
    required String title,
    required String description,
    double? rating,
  }) async {
    emit(AddOpinionsloading());
    FormData formData = FormData.fromMap({
      "Titel": title,
      "Description": description,
      "UsersId": userID,
      if (rating != null) "Rating": rating,
    });
    await dio.post('${baseUrl}UserReview/AddReview', data: formData).then((v) {
      if (v.statusCode == 200) {
        emit(AddOpinionsSuccess(message: 'Your Opinion Added Successfully'));
      } else {
        emit(AddOpinionsFailed(
            message: 'Failed with status code: ${v.statusCode}'));
        debugPrint('Failed: Status code ${v.statusCode}');
      }
    }).catchError((e) {
      emit(AddOpinionsFailed(message: 'Your opinion didn`t add Try later'));
      debugPrint('Error: $e');
    });
  }
  //===================>>> Delete Opinions <<<===================\\

  Future DeleteOpinions({
    required int id,
  }) async {
    emit(DeleteOpinionsloading());

    await dio.delete('${baseUrl}UserReview/DeleteReview', queryParameters: {
      "id": id,
    }).then((v) async {
      if (v.statusCode == 200) {
        await getOpinions();
        emit(DeleteOpinionsSuccess(
            message: 'Your Opinion Deleted Successfully'));
      } else {
        emit(DeleteOpinionsFailed(
            message: 'Failed with status code: ${v.statusCode}'));
        debugPrint('Failed: Status code ${v.statusCode}');
      }
    }).catchError((e) {
      emit(DeleteOpinionsFailed(
          message: 'Your opinion didn`t Delete Try later'));
      debugPrint('Error: $e');
    });
  }
}
