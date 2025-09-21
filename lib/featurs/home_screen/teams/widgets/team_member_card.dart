import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/featurs/home_screen/teams/cubit/teams_cubit.dart';
import 'package:dr_sami/featurs/home_screen/teams/model/team_model.dart';
import 'package:dr_sami/featurs/home_screen/teams/update_member.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';

import '../../../../core/constant_widgets/circle_progress.dart';

class TeamCard extends StatelessWidget {
  TeamCard({
    super.key,
    required this.teamMember,
  });
  TeamMember teamMember;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0.w),
          child: Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height / 1.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              gradient: LinearGradient(
                colors: [Colors.blueAccent.shade100, Colours.DarkBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Image with border and shadow
                Container(
                  // margin: EdgeInsets.only(top: 20.h, bottom: 10.h),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10.r,
                        offset: Offset(0, 5.h),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: '$imageUrl${teamMember.image}',
                      width: 170.w,
                      height: 170.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => customLoader(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                // Name Text with shadow
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: Text(
                    teamMember.titel!,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 5.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 5.h),
                // Position Text with styling
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: Text(
                    teamMember.position!,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
        isAdmin!
            ? Positioned(
                top: 20.w,
                right: 20.w,
                child: Row(
                  children: [
                    // Container(),
                    CircleAvatar(
                      backgroundColor: Colours.White,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => EditMember(
                                        teamMember: teamMember,
                                      )));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: Colours.DarkBlue,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    BlocConsumer<TeamsCubit, TeamsState>(
                      listener: (context, state) {
                        if (state is DeleteTeamsSuccess) {
                          showToast(content: state.message);
                        } else if (state is DeleteTeamsFailed) {
                          showToast(content: state.message);
                        }
                      },
                      builder: (context, state) {
                        return CircleAvatar(
                          backgroundColor: Colours.White,
                          child: ConditionBuilder(
                            condition: state is DeleteTeamsLoading,
                            ifFalse: IconButton(
                              onPressed: () {
                                context
                                    .read<TeamsCubit>()
                                    .deleteMember(id: teamMember.id!);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colours.DarkBlue,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
