import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/model/meeting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

part 'meeting_state.dart';

double? inDollar;

class MeetingCubit extends Cubit<MeetingState> {
  MeetingCubit() : super(MeetingInitial());
  MeetingCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();

  //================>>>> Convert Curruncy  <<<<================\\
//  https://v6.exchangerate-api.com/v6/1fc23ea9235e7c60bc86e050/latest/AED
  Future convertCurancy() async {
    emit(ConvertoLoading());
    log('Loading');

    var headers = {
      'x-rapidapi-key': '73475787b4mshe6a5828ca6232eap11e66ajsn7129e32caaab',
      'x-rapidapi-host': 'currency-conversion-and-exchange-rates.p.rapidapi.com'
    };
    var dio = Dio();
    var response = await dio.request(
      'https://currency-conversion-and-exchange-rates.p.rapidapi.com/latest?from=AED&to=USD&base=AED',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      // print(json.encode(response.data));
      inDollar = response.data['rates']['USD'];

      //     log(inDollar.toString());
      log('Success');
      emit(ConvertedSuccess());
    } else {
      print(response.statusMessage);
      //  log(e.toString());
      log('error currency limted');

      emit(ConvertedFailed());
    }
  }

  //================>>>> Call <<<<================\\
  void makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      emit(CallSuccess());
    } else {
      emit(CallFailed());
      throw 'Could not launch $url';
    }
  }
  //================>>>> Send Meeting URL To User <<<<================\\

  void sendWhatsAppMessage(String phone, String message) async {
    // Check and add country code if needed
    if (!phone.startsWith('+971') &&
        (phone.startsWith('5') || phone.startsWith('05'))) {
      phone = '+971${phone.replaceFirst(RegExp(r'^0'), '')}';
    } else if (!phone.startsWith('+2') && phone.startsWith('01')) {
      phone = '+2$phone';
    }

    final Uri whatsappUri = Uri.parse(
        "whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      showToast(
          content: 'WhatsApp is not installed or the URL could not be opened.');
      log("WhatsApp is not installed or the URL could not be opened.");
    }
  }

  void startMeeting(
    String url,
  ) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      showToast(content: 'The URL could not be opened.');
      log("WhatsApp is not installed or the URL could not be opened.");
    }
  }

  //================>>>> Get All Requst For User <<<<================\\
  List<MeetingRequest> userMeetingList = [];

  Future getAllRequsetForUser() async {
    emit(GetRequestsLoading());
    await dio.get(
      '${baseUrl}RequestMeet/GetAllRequestForUser',
      queryParameters: {
        "UserId": userID,
      },
    ).then((v) {
      if (v.statusCode == 200) {
        List<dynamic> data = v.data;
        List<Map<String, dynamic>> mapList =
            List<Map<String, dynamic>>.from(data);
        userMeetingList =
            mapList.map((json) => MeetingRequest.fromJson(json)).toList();
        emit(GetRequestsSuccess(message: ''));
      }
    }).catchError((e) {
      log('=======================================================');
      log(e.toString());
      emit(GetRequestsFailed(message: ''));
      log('=======================================================');
    });
  }

  //================>>>> Get All Requst For Admin <<<<================\\
  List<MeetingRequest> pendingList = [];
  int pending = 0;
  int approved = 0;
  int paied = 0;
  List<MeetingRequest> payAprrovedList = [];
  List<MeetingRequest> approveList = [];
  Future getAllRequsetForAdmin() async {
    emit(GetRequestsLoading());
    await dio
        .get(
      '${baseUrl}Admin/GetAllRequest',
    )
        .then((v) {
      if (v.statusCode == 200) {
        List<dynamic> data = v.data;

        for (int i = 0; i < data.length; i++) {
          if (data[i]['isApproved']) {
            if (data[i]['payment']) {
              payAprrovedList.add(MeetingRequest.fromJson(data[i]));
              paied = payAprrovedList.length;
            } else {
              approveList.add(MeetingRequest.fromJson(data[i]));
              approved = approveList.length;
            }
          } else if (data[i]['isApproved'] == false) {
            pendingList.add(MeetingRequest.fromJson(data[i]));
            pending = pendingList.length;
          }
        }
        emit(GetRequestsSuccess(message: ''));
      }
    }).catchError((e) {
      log('=======================================================');
      log(e.toString());
      emit(GetRequestsFailed(message: ''));
      log('=======================================================');
    });
  }

  //================>>>> Add Request <<<<================\\
  Future addRequest(
      {required String title, required String dsecription}) async {
    emit(AddRequestsLoading());
    FormData formData = FormData.fromMap({
      "Titel": title,
      "Description": dsecription,
      "UsersId": userID,
    });
    await dio
        .post('${baseUrl}RequestMeet/AddRequestMeet', data: formData)
        .then((v) {
      if (v.statusCode == 200) {
        emit(AddRequestsSuccess(message: 'Your Request send Seuccessfully ..'));
      }
    }).catchError((e) {
      log('=======================================================');
      log(e.toString());
      emit(AddRequestsFailed(message: 'Sorry Please Try Again'));
      log('=======================================================');
    });
  }

  //================>>>> Update Request <<<<================\\
  Future updateRequest(
      {required int id,
      required String title,
      required String dsecription}) async {
    emit(UpdateRequestsLoading());
    FormData formData = FormData.fromMap({
      "Titel": title,
      "Description": dsecription,
      "UsersId": userID,
    });
    await dio
        .put('${baseUrl}RequestMeet/UpdateRequestMeet',
            queryParameters: {
              "catID": id,
            },
            data: formData)
        .then((v) {
      if (v.statusCode == 200) {
        emit(UpdateRequestsSuccess(message: 'Updated Successfully..'));
      }
    }).catchError((e) {
      log('=======================================================');
      log(e.toString());
      emit(UpdateRequestsFailed(message: 'Sorry Try Later..'));
      log('=======================================================');
    });
  }

  //================>>>> Update Request Payment Status <<<<================\\
  Future updateRequestPaymentStatus(
      {required String phone, required int id}) async {
    emit(UpdateRequestStatusPaymentLoading());
    await dio.put('${baseUrl}RequestMeet/UserPayment/$id').then((v) {
      if (v.statusCode == 200) {
        // sendWhatsAppMessage(phone,
        //     ' Hello, You  pay consultaion cost on this bank account\'000 0000 00000 0000 00 \' and you will create meeting soon.');

        emit(UpdateRequestStatusPaymentSuccess(message: 'Marked as Paid'));
      }
    }).catchError((e) {
      log('=======================================================');
      log(e.toString());
      emit(UpdateRequestStatusPaymentFailed(message: 'Try Later'));
      log('=======================================================');
    });
  }

  //================>>>> Delete Request <<<<================\\
  Future deleteRequest({required int id}) async {
    emit(DeleteRequestsLoading());
    await dio.delete('${baseUrl}RequestMeet/DeleteRequest',
        queryParameters: {"id": id}).then((v) {
      if (v.statusCode == 200) {
        // getAllRequsetForAdmin();
        emit(DeleteRequestsSuccess(message: 'Deleted Successfully'));
      }
    }).catchError((e) {
      log('=======================================================');
      log(e.toString());
      emit(DeleteRequestsFailed(message: 'Sorry Try Again'));
      log('=======================================================');
    });
  }

  //================>>>> Approve Request <<<<================\\
  Future approveRequest(
      {required int id, required double price, required String phone}) async {
    emit(ApproveRequestsLoading());
    await dio.put('${baseUrl}Admin/AdminApprovedRequest/$id', queryParameters: {
      "price": price,
    }).then((v) {
      if (v.statusCode == 200) {
        // sendWhatsAppMessage(phone,
        //     ' Hello, Your Request a medical consultation has been approved .Now you Should pay consultaion cost on this bank account\'000 0000 00000 0000 00 \'  and you will be contacted by the doctor soon.');
        emit(ApproveRequestsSuccess(message: 'Approved Successfully'));
      }
    }).catchError((e) {
      log(e.toString());

      emit(ApproveRequestsFailed(message: 'Sorry Try Again'));
    });
  }

  //================>>>> Create Meeting <<<<================\\
  String? meetingUrl;
  String? startMeetingUrl;

  Future<void> createMeet({
    required String title,
    required String start,
    required String duration,
    required String phone,
  }) async {
    emit(CreateMeetingLoading());

    FormData formData = FormData.fromMap({
      "Title": title,
      "StartDateTime": start,
      "DurationInMinute": duration,
    });

    await dio.post('${baseUrl}Zoom/createMeeting', data: formData).then((v) {
      if (v.statusCode == 200 || v.statusCode == 201) {
        meetingUrl = v.data['data']['join_url'] ?? '';
        startMeetingUrl = v.data['data']['start_url'] ?? '';
        log(meetingUrl!);
        sendWhatsAppMessage(phone,
            ' Hello, I have scheduled a medical consultation for you. You can join the meeting in $start by clicking on the following link: $meetingUrl.');

        emit(CreateMeetingSuccess(message: 'Meeting Created Successfully'));
      } else {
        emit(CreateMeetingFailed(message: 'Unexpected error occurred'));
      }
    }).catchError((e) {
      log('=======================================================');
      log('Error==>> ${e.toString()}');
      emit(CreateMeetingFailed(message: 'Meeting Failed To Create'));
    });
  }
}
//2024-11-04T12:25:57Z