import 'package:dr_sami/featurs/home_screen/requset_meet/cubit/meeting_cubit.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/widgets/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/config/config.dart';
import '../../../core/constant_widgets/toast.dart';

class AprrovedNotPayRequst extends StatelessWidget {
  const AprrovedNotPayRequst({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingCubit()..getAllRequsetForAdmin(),
      child: BlocConsumer<MeetingCubit, MeetingState>(
        listener: (context, state) {
          var cubit = MeetingCubit().get(context);

          if (state is DeleteRequestsSuccess) {
            showToast(content: state.message);
            // context.read<MeetingCubit>().getAllRequsetForAdmin();
            // cubit.approveList = [];
          } else if (state is DeleteRequestsFailed) {
            showToast(content: state.message);
          } else if (state is UpdateRequestStatusPaymentSuccess) {
            showToast(content: state.message);
            cubit.approveList = [];
            context.read<MeetingCubit>().getAllRequsetForAdmin();
          } else if (state is UpdateRequestsSuccess) {
            showToast(content: state.message);
            cubit.approveList = [];

            // context.read<MeetingCubit>().getAllRequsetForAdmin();
          }
        },
        builder: (context, state) {
          var cubit = MeetingCubit().get(context);
          // return cubit.approveList.isEmpty
          //     ? Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Image.asset('assets/images/nodata.png'),
          //           Text(
          //             config.localization['nodata'],
          //             style: TextStyle(
          //               fontSize: 25.sp,
          //               color: Colors.black12,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           )
          //         ],
          //       )
          //     : SingleChildScrollView(
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(vertical: 16.0.w),
          //           child: Column(
          //             children: [
          //               for (int i = 0; i < cubit.approveList.length; i++)
          //                 RequestCard(
          //                   index: i,
          //                   model: cubit.approveList[i],
          //                 ),
          //             ],
          //           ),
          //         ),
          // );

          return state is GetRequestsLoading
              ? Skeletonizer(
                  containersColor: Colors.grey.withValues(alpha: .02),
                  child: RequestCard(
                    index: 1,
                    model: meetingRequest,
                  ),
                )
              : cubit.approveList.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/nodata.png'),
                        Text(
                          config.localization['nodata'],
                          style: TextStyle(
                            fontSize: 25.sp,
                            color: Colors.black12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < cubit.approveList.length; i++)
                            RequestCard(
                              index: i,
                              model: cubit.approveList[i],
                            ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
//  appBar: AppBar(
//                 title: Text(
//                   config.localization['requestMeeting'],
//                   style: TextStyles.lightBlue20blod,
//                 ),
//               ),
