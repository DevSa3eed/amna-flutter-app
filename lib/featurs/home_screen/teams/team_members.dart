import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:dr_sami/featurs/home_screen/teams/cubit/teams_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/condition.dart';
import 'widgets/team_member_card.dart';

class TeamMembers extends StatelessWidget {
  const TeamMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeamsCubit()..getTeamMembers(),
      child: BlocConsumer<TeamsCubit, TeamsState>(
        listener: (context, state) {
          if (state is DeleteTeamsSuccess || state is TeamsDeletedAndRefresh) {
            context.read<TeamsCubit>().getTeamMembers();
          }
        },
        builder: (context, state) {
          var cubit = TeamsCubit().get(context);
          return cubit.listOfMembers.isEmpty
              ? Container()
              : Padding(
                  padding: EdgeInsets.all(16.w),
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height / 1.9,
                    child: CarouselSlider(
                      items: [
                        for (int i = 0; i < cubit.listOfMembers.length; i++)
                          ConditionBuilder(
                            condition: state is TeamsLoading,
                            ifFalse: TeamCard(
                              teamMember: cubit.listOfMembers[i],
                            ),
                          ),
                      ],
                      // controller: buttonCarouselController,
                      options: CarouselOptions(
                        height: MediaQuery.sizeOf(context).height / 1.9,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 2000),
                        pauseAutoPlayOnTouch: true,
                        autoPlay: true,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                        aspectRatio: 1,
                        initialPage: 2,
                        pageSnapping: false,
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}
