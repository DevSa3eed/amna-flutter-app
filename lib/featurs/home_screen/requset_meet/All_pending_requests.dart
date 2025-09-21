// ignore_for_file: use_build_context_synchronously

import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/cubit/meeting_cubit.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/widgets/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/constant_widgets/toast.dart';

class PendingRequst extends StatelessWidget {
  const PendingRequst({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingCubit()..getAllRequsetForAdmin(),
      child: BlocConsumer<MeetingCubit, MeetingState>(
        listener: (context, state) async {
          final cubit = MeetingCubit().get(context);

          if (state is DeleteRequestsSuccess) {
            cubit.pendingList = [];
            await context.read<MeetingCubit>().getAllRequsetForAdmin();
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
          if (state is UpdateRequestsSuccess) {
          } else if (state is UpdateRequestsFailed) {
            showToast(content: state.message);
          }
        },
        builder: (context, state) {
          final cubit = MeetingCubit().get(context);

          // return cubit.pendingList.isEmpty
          return state is GetRequestsLoading
              ? Skeletonizer(
                  containersColor: Colors.grey.withOpacity(.02),
                  child: RequestCard(
                    index: 1,
                    model: meetingRequest,
                  ),
                )
              : cubit.pendingList.isEmpty
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
                          for (int i = 0; i < cubit.pendingList.length; i++)
                            RequestCard(
                              index: i,
                              model: cubit.pendingList[i],
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
//                   config.localization['meeting request'],
//                   style: TextStyles.lightBlue20blod,
//                 ),
//               ),