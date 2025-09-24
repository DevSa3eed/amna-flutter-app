// ignore_for_file: must_be_immutable, collection_methods_unrelated_type, depend_on_referenced_packages

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/services/notification_service.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/featurs/auth/widgets/textField.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/cubit/meeting_cubit.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/model/meeting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:quickalert/quickalert.dart';

import '../../../../constants/cached_constants/cached_constants.dart';
import '../../../../core/constant_widgets/circle_progress.dart';
import '../../../../core/constant_widgets/toast.dart';
import '../../../../core/theme/text_styles/text_styeles.dart';
import '../../../../routes/routes.dart';
import '../../../auth/profile/cubit/profile_cubit.dart';
import 'button.dart';

class RequestCard extends StatelessWidget {
  RequestCard({required this.model, required this.index, super.key});

  MeetingRequest model;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    // Check if MeetingCubit is available in the context
    try {
      context.read<MeetingCubit>();
    } catch (e) {
      // If MeetingCubit is not available, return a simple card without BLoC functionality
      return _buildSimpleCard(context, textController);
    }

    return BlocConsumer<MeetingCubit, MeetingState>(
      listener: (context, state) async {
        if (state is DeleteRequestsSuccess) {
          context.read<MeetingCubit>().getAllRequsetForAdmin();
          showToast(content: state.message);
        } else if (state is DeleteRequestsFailed) {
          showToast(content: state.message);
        }
        // if (state is ApproveRequestsSuccess) {
        //   cubit.pendingList = [];
        //   cubit.pendingList.length = 0;
        //   context.read<MeetingCubit>().getAllRequsetForAdmin();
        //   showToast(content: state.message);
        // } else if (state is ApproveRequestsFailed) {
        //   showToast(content: state.message);
        // }
        else if (state is UpdateRequestStatusPaymentSuccess) {
          showToast(content: state.message);
          context.read<MeetingCubit>().getAllRequsetForAdmin();
        } else if (state is UpdateRequestStatusPaymentFailed) {
          showToast(content: state.message);
        }
      },
      builder: (context, state) {
        var cubit = MeetingCubit().get(context);
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.all(10.w),

              width: double.infinity,
              // height:150,
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  // color: Colours.LightBlue,
                  color: Colors.black.withValues(alpha: .07),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25), // Shadow color
                    spreadRadius: 1, // How much the shadow spreads
                    blurRadius: 5, // How blurry the shadow is
                    offset: const Offset(5, 5), // Offset of the shadow (x, y)
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 15.w,
                            ),
                            state is GetProfileLoading
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.h,
                                    child: Center(child: customLoader()))
                                : model.user?.imageCover == null
                                    ? Padding(
                                        padding: EdgeInsets.all(8.0.w),
                                        child: Image.asset(
                                          'assets/images/account.png',
                                          fit: BoxFit.contain,
                                          width: 40.w,
                                          height: 40.w,
                                          color: Colours.LightBlue,
                                        ),
                                      )
                                    : ClipOval(
                                        child: CachedNetworkImage(
                                          width: 50.w,
                                          height: 50.w,
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              '$imageUrl${model.user?.imageCover ?? ''}',
                                          // placeholder: (context, url) =>
                                          //     const CircularProgressIndicator(), // While loading
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            'assets/images/account.png',
                                            fit: BoxFit.contain,
                                            width: 50.w,
                                            height: 50.w,
                                            color: Colours.LightBlue,
                                          ), // If there is an error
                                        ),
                                      ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                state is GetProfileLoading
                                    ? customLoader()
                                    : model.user?.fullName != null
                                        ? Text(
                                            model.user!.fullName!,
                                            style: TextStyles.lightBlue16blod,
                                          )
                                        : Container(),
                              ],
                            )
                          ],
                        ),
                        Text(
                          model.titel ?? 'No Title',
                          style: TextStyle(
                            color: Colours.LightBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          height: 5.w,
                        ),
                        Text(
                          model.description ?? 'No Description',
                          style: TextStyle(
                            color: Colours.Black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        isAdmin!
                            ? !model.isApproved!
                                ? CustomTextFeild(
                                    controller: textController,
                                    label: 'Price',
                                    isPassword: false,
                                    iconPre: Icons.monetization_on_outlined,
                                    type: TextInputType.number,
                                  )
                                : Container()
                            : Container(),
                      ],
                    ),
                    isAdmin!
                        ? Row(
                            children: [
                              model.isApproved!
                                  ? model.payment!
                                      ? Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SmallButton(
                                                condition: false,
                                                color: Colours.DarkBlue,
                                                text: 'Call',
                                                fun: () {
                                                  cubit.makePhoneCall(
                                                      model.user?.phoneNumber ??
                                                          '');
                                                },
                                              ),
                                              SmallButton(
                                                condition: state
                                                    is DeleteRequestsLoading,
                                                color: Colors.red,
                                                text: isAdmin!
                                                    ? !model.payment!
                                                        ? 'cancel '
                                                        : 'Finish'
                                                    : 'Delete',
                                                fun: () {
                                                  cubit.deleteRequest(
                                                      id: model.id!);

                                                  cubit.pendingList
                                                      .remove(index);
                                                  cubit.pendingList.length = 0;
                                                  cubit.approveList
                                                      .remove(index);
                                                  cubit.approveList.length = 0;
                                                  cubit.payAprrovedList
                                                      .remove(index);
                                                  cubit.payAprrovedList.length =
                                                      0;
                                                  cubit.getAllRequsetForAdmin();
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      : SmallButton(
                                          condition:
                                              state is DeleteRequestsLoading,
                                          color: Colors.red,
                                          text: isAdmin!
                                              ? !model.payment!
                                                  ? 'cancel '
                                                  : 'Finish'
                                              : 'Delete',
                                          fun: () {
                                            cubit.deleteRequest(id: model.id!);

                                            cubit.pendingList.remove(index);
                                            cubit.pendingList.length = 0;
                                            cubit.approveList.remove(index);
                                            cubit.approveList.length = 0;
                                            cubit.payAprrovedList.remove(index);
                                            cubit.payAprrovedList.length = 0;
                                            cubit.getAllRequsetForAdmin();
                                          },
                                        )
                                  : Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SmallButton(
                                            condition: false,
                                            color: Colours.DarkBlue,
                                            text: 'Approve',
                                            fun: () async {
                                              context
                                                  .read<MeetingCubit>()
                                                  .convertCurancy();

                                              state is ConvertoLoading
                                                  ? customLoader()
                                                  // : showAlertWithTextField(
                                                  //     model.id!,
                                                  //     model.user!.phoneNumber!,
                                                  //     context);

                                                  : textController
                                                          .text.isNotEmpty
                                                      ? await cubit.approveRequest(
                                                          id: model.id!,
                                                          price: double.parse(
                                                                  textController
                                                                      .text) *
                                                              inDollar!,
                                                          phone: model.user
                                                                  ?.phoneNumber ??
                                                              '')
                                                      : showToast(
                                                          content:
                                                              'Enter The Price!!');
                                              cubit.pendingList = [];
                                              cubit.pendingList.length = 0;
                                              await cubit
                                                  .getAllRequsetForAdmin();
                                            },
                                          ),
                                          SmallButton(
                                            condition:
                                                state is DeleteRequestsLoading,
                                            color: Colors.red,
                                            text: isAdmin!
                                                ? !model.payment!
                                                    ? 'cancel '
                                                    : 'Finish'
                                                : 'Delete',
                                            fun: () {
                                              cubit.deleteRequest(
                                                  id: model.id!);

                                              cubit.pendingList.remove(index);
                                              cubit.pendingList.length = 0;
                                              cubit.approveList.remove(index);
                                              cubit.approveList.length = 0;
                                              cubit.payAprrovedList
                                                  .remove(index);
                                              cubit.payAprrovedList.length = 0;
                                              cubit.getAllRequsetForAdmin();
                                            },
                                          )
                                        ],
                                      ),
                                    )
                            ],
                          )
                        : !model.isApproved!
                            ? SmallButton(
                                condition: state is DeleteRequestsLoading,
                                color: Colors.red,
                                text: isAdmin!
                                    ? !model.payment!
                                        ? 'cancel '
                                        : 'Finish'
                                    : 'Delete',
                                fun: () {
                                  cubit.deleteRequest(id: model.id!);

                                  cubit.pendingList.remove(index);
                                  cubit.pendingList.length = 0;
                                  cubit.approveList.remove(index);
                                  cubit.approveList.length = 0;
                                  cubit.payAprrovedList.remove(index);
                                  cubit.payAprrovedList.length = 0;
                                  cubit.getAllRequsetForAdmin();
                                },
                              )
                            : model.payment!
                                ? SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width - 62.w,
                                    child: Center(
                                      child: Text(
                                        config.localization['contact'],
                                        maxLines: 2,
                                        style: TextStyles.lightBlue16blod,
                                      ),
                                    ),
                                  )
                                : Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width -
                                                62.w,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SmallButton(
                                              condition: state
                                                  is UpdateRequestStatusPaymentLoading,
                                              color: Colours.DarkBlue,
                                              widget: Image.asset(
                                                'assets/icons/paypal.png',
                                                width: 22.w,
                                              ),
                                              text:
                                                  'Pay ${model.price ?? 0} \$',
                                              fun: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          PaypalCheckoutView(
                                                    sandboxMode: true,
                                                    clientId:
                                                        "AYoetphnKLUymcokLVTD0zpxedX9qseZ_0w7dJ6ka16T0Gg6M-8huytoZt_Gbfj0jnrKhO5h9S1KfDES",
                                                    secretKey:
                                                        "EMnUVjk6nNcggEoaOLlqY8J8yj5s0IVpc8PSJHRN5eKSToSUgiKDOJ16-2os7T2AHo3Suu3cK2_lCYOr",
                                                    transactions: [
                                                      {
                                                        "amount": {
                                                          "total":
                                                              '${model.price ?? 0}',
                                                          "currency": "USD",
                                                          "details": {
                                                            "subtotal":
                                                                '${model.price ?? 0}',
                                                            "shipping": '0',
                                                            "shipping_discount":
                                                                0
                                                          }
                                                        },
                                                        "description":
                                                            "The payment transaction description.",
                                                        "item_list": {
                                                          "items": [
                                                            {
                                                              "name": "Apple",
                                                              "quantity": 1,
                                                              "price":
                                                                  '${model.price ?? 0}',
                                                              "currency": "USD"
                                                            },
                                                          ],
                                                        }
                                                      }
                                                    ],
                                                    note:
                                                        "Contact us for any questions on your order.",
                                                    onSuccess:
                                                        (Map params) async {
                                                      log("onSuccess: $params");
                                                      // Navigator.pop(context);
                                                      Navigator
                                                          .pushReplacementNamed(
                                                              context,
                                                              Routes
                                                                  .userRequestsMeetRoute);
                                                      cubit.updateRequestPaymentStatus(
                                                          phone: model.user
                                                                  ?.phoneNumber ??
                                                              '',
                                                          id: model.id!);

                                                      // Send payment confirmation notification
                                                      try {
                                                        await NotificationService
                                                            .sendPaymentConfirmation(
                                                          appointmentId: model
                                                              .id
                                                              .toString(),
                                                          amount: model.price ??
                                                              0.0,
                                                        );
                                                      } catch (notificationError) {
                                                        log('Payment notification error: $notificationError');
                                                      }

                                                      QuickAlert.show(
                                                        context: context,
                                                        type: QuickAlertType
                                                            .success,
                                                        text:
                                                            'Transaction Completed Successfully!',
                                                      );
                                                    },
                                                    onError: (error) {
                                                      log("onError: $error");
                                                      Navigator.pop(context);
                                                      // QuickAlert.show(
                                                      //   context: context,
                                                      //   type: QuickAlertType
                                                      //       .error,
                                                      //   title: 'Oops...',
                                                      //   text:
                                                      //       'Sorry, something went wrong',
                                                      // );
                                                      QuickAlert.show(
                                                        context: context,
                                                        type: QuickAlertType
                                                            .success,
                                                        text:
                                                            'Transaction Completed Successfully!',
                                                      );
                                                    },
                                                    onCancel: () {
                                                      log('cancelled:');
                                                      Navigator.pop(context);
                                                      QuickAlert.show(
                                                        context: context,
                                                        type:
                                                            QuickAlertType.info,
                                                        text:
                                                            'Are you sure you want to cancel?',
                                                      );
                                                    },
                                                  ),
                                                ));
                                              },
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            SmallButton(
                                              condition: state
                                                  is DeleteRequestsLoading,
                                              color: Colors.red,
                                              text: isAdmin!
                                                  ? !model.payment!
                                                      ? 'cancel '
                                                      : 'Finish'
                                                  : 'Delete',
                                              fun: () {
                                                cubit.deleteRequest(
                                                    id: model.id!);

                                                cubit.pendingList.remove(index);
                                                cubit.pendingList.length = 0;
                                                cubit.approveList.remove(index);
                                                cubit.approveList.length = 0;
                                                cubit.payAprrovedList
                                                    .remove(index);
                                                cubit.payAprrovedList.length =
                                                    0;
                                                cubit.getAllRequsetForAdmin();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                    SizedBox(
                      height: 10.h,
                    ),
                    inDollar == null
                        ? Container()
                        : Text(
                            "${((model.price ?? 0) / (inDollar ?? 1)).round()} AED = ${(model.price ?? 0).toString()} \$",
                            style: TextStyles.lightBlue16blod,
                          ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  // Simple card without BLoC functionality when MeetingCubit is not available
  Widget _buildSimpleCard(
      BuildContext context, TextEditingController textController) {
    return Container(
      margin: EdgeInsets.all(10.w),
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colours.White,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.titel ?? 'No Title',
            style: TextStyles.lightBlue20blod,
          ),
          SizedBox(height: 10.h),
          Text(
            model.description ?? 'No Description',
            style: TextStyles.lightBlue16blod,
          ),
          SizedBox(height: 10.h),
          if (model.user != null) ...[
            Text(
              'User: ${model.user!.fullName ?? 'Unknown'}',
              style: TextStyles.lightBlue16blod,
            ),
            SizedBox(height: 5.h),
            Text(
              'Phone: ${model.user!.phoneNumber ?? 'N/A'}',
              style: TextStyles.lightBlue16blod,
            ),
          ],
          SizedBox(height: 10.h),
          Text(
            'Price: \$${model.price?.toString() ?? 'N/A'}',
            style: TextStyles.lightBlue16blod,
          ),
        ],
      ),
    );
  }
}

User user = User(
  usersId: "12345",
  imageCover: image,
  fullName: "John Doe",
  phoneNumber: "+123456789",
);

// Create a MeetingRequest object with custom data
MeetingRequest meetingRequest = MeetingRequest(
  id: 1,
  titel: "Project Discussion",
  description: "Discussion about the new project requirements.",
  isApproved: true,
  payment: false,
  price: 150.0,
  user: user,
);
