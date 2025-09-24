import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/widgets/custom_button.dart';
import 'package:dr_sami/featurs/auth/widgets/textField.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/cubit/meeting_cubit.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequstMeet extends StatelessWidget {
  const RequstMeet({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> requsetMeat = GlobalKey<FormState>();
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    return BlocProvider(
      create: (context) => MeetingCubit(),
      child: BlocConsumer<MeetingCubit, MeetingState>(
        listener: (context, state) {
          if (state is AddRequestsSuccess) {
            showToast(content: state.message);
          } else if (state is AddRequestsFailed) {
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/meet Requset.png',
                    width: double.infinity,
                    // height: 200.h,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20.h),
                  Form(
                    key: requsetMeat,
                    child: Column(
                      children: [
                        CustomTextFeild(
                          controller: titleController,
                          label: config.localization['complaint'],
                          isPassword: false,
                          iconPre: Icons.text_fields_outlined,
                          type: TextInputType.text,
                        ),
                        CustomTextFeild(
                          controller: descriptionController,
                          label: config.localization['desc'],
                          isPassword: false,
                          iconPre: Icons.text_fields_outlined,
                          type: TextInputType.text,
                        ),
                        SizedBox(height: 20.h),
                        ConditionBuilder(
                          condition: state is AddRequestsLoading,
                          ifFalse: CustomBotton(
                              navigate_fun: () {
                                if (requsetMeat.currentState!.validate()) {
                                  cubit.addRequest(
                                    title: titleController.text,
                                    dsecription: descriptionController.text,
                                  );
                                }
                              },
                              lable: config.localization['request'],
                              fontSize: 20.sp),
                        ),
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
