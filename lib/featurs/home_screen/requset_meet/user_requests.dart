import 'package:dr_sami/featurs/home_screen/requset_meet/cubit/meeting_cubit.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/widgets/request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../constants/cached_constants/cached_constants.dart';
import '../../../core/config/config.dart';
import '../../../core/constant_widgets/toast.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../../../routes/routes.dart';

class UserRequests extends StatelessWidget {
  const UserRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MeetingCubit()..getAllRequsetForUser(),
      child: BlocConsumer<MeetingCubit, MeetingState>(
        listener: (context, state) {
          if (state is DeleteRequestsSuccess) {
            showToast(content: state.message);
            context.read<MeetingCubit>().userMeetingList.length = 0;
            context.read<MeetingCubit>().getAllRequsetForUser();
          } else if (state is DeleteRequestsFailed) {
            showToast(content: state.message);
          }
        },
        builder: (context, state) {
          var cubit = MeetingCubit().get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                config.localization['requestMeeting'],
                style: TextStyles.lightBlue20blod,
              ),
            ),
            backgroundColor: Colours.White,
            body: state is GetRequestsLoading
                ? Skeletonizer(
                    containersColor: Colors.grey.withValues(alpha: .02),
                    child: RequestCard(
                      index: 1,
                      model: meetingRequest,
                    ),
                  )
                : cubit.userMeetingList.isEmpty
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
                            for (int i = 0;
                                i < cubit.userMeetingList.length;
                                i++)
                              RequestCard(
                                index: i,
                                model: cubit.userMeetingList[i],
                              ),
                          ],
                        ),
                      ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (userID != null) {
                  Navigator.pushNamed(context, Routes.requsetMeatRoute);
                } else {
                  Navigator.pushNamed(context, Routes.loginFirstRoute);
                }
              },
              shape: const CircleBorder(),
              backgroundColor: Colours.DarkBlue,
              child: Icon(
                IconlyBroken.call,
                size: 30.w,
                color: Colours.White,
              ),
            ),
          );
        },
      ),
    );
  }
}
