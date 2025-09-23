import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/core/widgets/star_rating_widget.dart';
import 'package:dr_sami/featurs/auth/widgets/custom_button.dart';
import 'package:dr_sami/featurs/auth/widgets/textField.dart';
import 'package:dr_sami/featurs/home_screen/opinions/cubit/opinions_cubit.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddOpinion extends StatefulWidget {
  const AddOpinion({super.key});

  @override
  State<AddOpinion> createState() => _AddOpinionState();
}

class _AddOpinionState extends State<AddOpinion> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final GlobalKey<FormState> opinionFormKey = GlobalKey<FormState>();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpinionsCubit(),
      child: BlocConsumer<OpinionsCubit, OpinionsState>(
        listener: (context, state) {
          if (state is AddOpinionsSuccess) {
            context.read<OpinionsCubit>().getOpinions();
            Navigator.popAndPushNamed(context, Routes.homeRoute);
            showToast(content: state.message);
          } else if (state is AddOpinionsFailed) {
            showToast(content: state.message);
          }
        },
        builder: (context, state) {
          var cubit = OpinionsCubit().get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                config.localization['addOPinion'],
                style: TextStyles.lightBlue20blod,
              ),
            ),
            backgroundColor: Colours.White,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/add opinion.png',
                    width: double.infinity,
                  ),
                  Form(
                    key: opinionFormKey,
                    child: Column(
                      children: [
                        CustomTextFeild(
                            controller: titleController,
                            label: config.localization['title'],
                            isPassword: false,
                            iconPre: Icons.text_fields_rounded,
                            type: TextInputType.text),
                        CustomTextFeild(
                            controller: descController,
                            label: config.localization['desc'],
                            isPassword: false,
                            iconPre: Icons.text_fields_rounded,
                            type: TextInputType.text),

                        // Rating section
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rate your experience',
                                style: TextStyles.black16blod,
                              ),
                              SizedBox(height: 10.h),
                              StarRatingWidget(
                                initialRating: _rating,
                                onRatingChanged: (rating) {
                                  setState(() {
                                    _rating = rating;
                                  });
                                },
                                starSize: 30.0,
                                activeColor: Colors.amber,
                                inactiveColor: Colors.grey,
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                _rating > 0
                                    ? '${_rating.toStringAsFixed(1)} stars'
                                    : 'No rating',
                                style: TextStyles.grey14,
                              ),
                            ],
                          ),
                        ),

                        ConditionBuilder(
                            condition: state is AddOpinionsloading,
                            ifFalse: CustomBotton(
                                navigate_fun: () {
                                  if (opinionFormKey.currentState!.validate()) {
                                    cubit.AddOpinions(
                                      title: titleController.text,
                                      description: descController.text,
                                      rating: _rating > 0 ? _rating : null,
                                    );
                                  }
                                },
                                lable: config.localization['addOPinion'],
                                fontSize: 20.sp))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
