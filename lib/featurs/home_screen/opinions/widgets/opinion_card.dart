// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/featurs/home_screen/opinions/Edit_opinion.dart';
import 'package:dr_sami/featurs/home_screen/opinions/cubit/opinions_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/cached_constants/cached_constants.dart';
import '../../../../core/constant_widgets/circle_progress.dart';
import '../../../../core/theme/text_styles/text_styeles.dart';
import '../../../auth/profile/cubit/profile_cubit.dart';
import '../model/opinion_model.dart';

class CustomerOpinions extends StatefulWidget {
  CustomerOpinions({required this.model, super.key});

  Opinions model;

  @override
  State<CustomerOpinions> createState() => _CustomerOpinionsState();
}

class _CustomerOpinionsState extends State<CustomerOpinions> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OpinionsCubit, OpinionsState>(
      listener: (context, state) {
        if (state is DeleteOpinionsSuccess) {
          context.read<OpinionsCubit>().getOpinions();
          showToast(content: state.message);
        } else if (state is DeleteOpinionsFailed) {
          showToast(content: state.message);
        }
      },
      builder: (context, state) {
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
                  color: Colors.black.withOpacity(.07),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25), // Shadow color
                    spreadRadius: 1, // How much the shadow spreads
                    blurRadius: 5, // How blurry the shadow is
                    offset: const Offset(5, 5), // Offset of the shadow (x, y)
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
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
                            : widget.model.user!.imageCover == null
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
                                          '$imageUrl${widget.model.user!.imageCover!}',
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(), // While loading
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
                                : widget.model.user!.fullName != null
                                    ? Text(
                                        widget.model.user!.fullName!,
                                        style: TextStyles.lightBlue16blod,
                                      )
                                    : Container(),
                          ],
                        )
                      ],
                    ),
                    Text(
                      widget.model.titel!,
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
                      widget.model.description!,
                      style: TextStyle(
                        color: Colours.Black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
            isAdmin! || widget.model.user!.usersId == userID
                ? Padding(
                    padding: EdgeInsets.all(15.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colours.DarkBlue,
                          radius: 20.r,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditOpinion(
                                      opinionModel: widget.model,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colours.White,
                              )),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        CircleAvatar(
                          backgroundColor: Colours.DarkBlue,
                          radius: 20.r,
                          child: state is DeleteOpinionsloading
                              ? customLoader()
                              : IconButton(
                                  onPressed: () {
                                    context
                                        .read<OpinionsCubit>()
                                        .DeleteOpinions(id: widget.model.id!);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colours.White,
                                  )),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }
}
