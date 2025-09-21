import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dr_sami/featurs/home_screen/baners/model/banner_model.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  BannersCubit() : super(BannersInitial());
  BannersCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();
  //************* - Function to capture an image from the gallary - *************\\
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

  //======================>> Add Banner <<======================\\
  Future AddBanner({
    required String title,
    required String desc,
  }) async {
    FormData formData = FormData.fromMap({
      "Titel": title,
      "Description": desc,
      "Image": await MultipartFile.fromFile(imageFile!.path),
    });
    emit(AddBannersLoading());

    await dio.post('${baseUrl}Banner/AddBanner', data: formData).then((value) {
      if (value.statusCode == 200) {
        log('===========>>>Success<<<=============');

        emit(AddBannersSuccessful(message: 'Banner Added Successfully'));
      }
    }).catchError((onError) {
      emit(AddBannersFailed(message: 'Banner didn\'t add now'));
      log('===========>>>${onError.toString()}<<<=============');
    });
  }

  //======================>> Edit Banner <<======================\\
  Future EditBanner({
    required int bannerId,
    required String title,
    required String desc,
  }) async {
    FormData formData = FormData.fromMap({
      "Titel": title,
      "Description": desc,
      "Image": await MultipartFile.fromFile(imageFile!.path),
    });
    emit(EditBannerLoading());

    await dio
        .put('${baseUrl}Banner/UpdateBanner', data: formData, queryParameters: {
      "BanID": bannerId,
    }).then((value) {
      if (value.statusCode == 200) {
        log('===========>>>Success<<<=============');

        emit(EditBannerSuccessful(message: 'Banner Updated Successfully'));
      }
    }).catchError((onError) {
      emit(EditBannerFailed(message: 'Banner didn\'t updated now'));
      log('===========>>>${onError.toString()}<<<=============');
    });
  }
  // Future EditBanner({
  //   required int bannerId,
  //   required String title,
  //   required String desc,
  // }) async {
  //   FormData formData = FormData.fromMap({
  //     "Titel": title,
  //     "Description": desc,
  //     "Image": await MultipartFile.fromFile(imageFile!.path),
  //   });
  //   emit(EditBannerLoading());

  //   await DioHelper.put(url: 'Banner/UpdateBanner', data: formData, query: {
  //     "BanID": bannerId,
  //   }).then((value) {
  //     if (value.statusCode == 200) {
  //       log('===========>>>Success<<<=============');

  //       emit(EditBannerSuccessful(message: 'Banner Updated Successfully'));
  //     }
  //   }).catchError((onError) {
  //     emit(EditBannerFailed(message: 'Banner didn\'t updated now'));
  //     log('===========>>>${onError.toString()}<<<=============');
  //   });
  // }

  //======================>> Delete Banner <<======================\\
  // Future DeleteBanner({
  //   required int bannerId,
  // }) async {
  //   emit(DeleteBannerLoading());
  //   log('===========>>>$bannerId<<<=============');
  //   await DioHelper.delete(
  //     url: 'Banner/DeleteBanner?id=$bannerId',

  //     // query: {
  //     //   "id": bannerId,
  //     // }
  //   ).then((value) {
  //     if (value.statusCode == 200) {
  //       log('===========>>>Success<<<=============');

  //       emit(DeleteBannerSuccessful(message: 'Banner Deleted Successfully'));
  //     }
  //   }).catchError((onError) {
  //     emit(DeleteBannerFailed(message: 'Banner didn\'t deleted now'));
  //     log('===========>>>${onError.toString()}<<<=============');
  //   });
  // }

  Future DeleteBanner({
    required int bannerId,
  }) async {
    await dio.delete('${baseUrl}Banner/DeleteBanner', queryParameters: {
      "id": bannerId,
    }).then((v) {
      if (v.statusCode == 200) {
        log('===========>>>Success<<<=============');

        emit(DeleteBannerSuccessful(message: 'Banner Deleted Successfully'));
      }
    }).catchError((e) {
      emit(DeleteBannerFailed(message: 'Banner didn\'t deleted now'));
      log('===========>>>${onError.toString()}<<<=============');
    });
  }

  //======================>> Get All Banner <<======================\\
  Banners? bannerModel;
  List? listOfBanners = [];
  Future getAllBanners() async {
    emit(GetBannersLoading());
    await dio
        .get(
      '$baseUrl$bannerGetterUrl',
    )
        .then((value) {
      if (value.statusCode == 200) {
        List<dynamic> data = value.data;
        List<Map<String, dynamic>> mapList =
            List<Map<String, dynamic>>.from(data);
        listOfBanners = mapList.map((json) => Banners.fromJson(json)).toList();
        emit(GetAllBannersSuccessful(message: 'Welcome TO AMNA'));
      }
    }).catchError((onError) {
      emit(GetBannersFailed(message: 'Failed to Fetch Banners'));
      log('==========>>${onError.toString()}');
    });
  }
}
