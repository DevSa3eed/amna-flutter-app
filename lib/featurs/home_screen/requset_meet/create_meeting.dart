// ignore_for_file: use_build_context_synchronously

import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/extensions/media_values.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/widgets/custom_Button.dart';
import 'package:dr_sami/featurs/home_screen/requset_meet/cubit/meeting_cubit.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:flutter/material.dart';
import 'package:dr_sami/featurs/auth/widgets/textField.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/config/config.dart';

class CreateMeeting extends StatelessWidget {
  const CreateMeeting({required this.phone, super.key});
  final String phone;
  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController durationController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    GlobalKey<FormState> creatrMeetKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (context) => MeetingCubit(),
      child: BlocConsumer<MeetingCubit, MeetingState>(
        listener: (context, state) {
          if (state is CreateMeetingSuccess) {
            showToast(content: state.message);
          } else if (state is CreateMeetingFailed) {
            showToast(content: state.message);
          }
        },
        builder: (context, state) {
          MeetingCubit cubit = MeetingCubit().get(context);
          return Scaffold(
            backgroundColor: Colours.White,
            appBar: AppBar(
              title: Text(
                'Create Meeting ',
                style: TextStyles.lightBlue20blod,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(15.0.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.asset(
                        'assets/images/zoom.jpg',
                        width: double.infinity,
                        height: context.height / 3,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Form(
                    key: creatrMeetKey,
                    child: Column(
                      children: [
                        CustomTextFeild(
                          controller: titleController,
                          label: config.localization['title'],
                          isPassword: false,
                          iconPre: Icons.text_fields_outlined,
                          type: TextInputType.text,
                        ),
                        CustomTextFeild(
                          controller: timeController,
                          label: 'time',
                          isPassword: false,
                          iconPre: Icons.text_fields_outlined,
                          type: TextInputType.text,
                          fun: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Colours.DarkBlue,
                                        onPrimary: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      dialogBackgroundColor: Colors.white,
                                    ),
                                    child: child!,
                                  );
                                }).then((selectedDate) {
                              if (selectedDate != null) {
                                showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                              primary: Colours.DarkBlue,
                                              onPrimary: Colors.white,
                                              onSurface: Colors.black,
                                              onSecondary: Colours.DarkBlue),
                                          dialogBackgroundColor: Colors.white,
                                        ),
                                        child: child!,
                                      );
                                    }).then((selectedTime) {
                                  if (selectedTime != null) {
                                    final selectedDateTime = DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    );
                                    timeController.text =
                                        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                                            .format(selectedDateTime.toUtc());
                                  }
                                });
                              }
                            });
                          },
                        ),
                        CustomTextFeild(
                          controller: durationController,
                          label: 'duration',
                          isPassword: false,
                          iconPre: Icons.text_fields_outlined,
                          type: TextInputType.number,
                        ),
                        ConditionBuilder(
                            condition: state is CreateMeetingLoading,
                            ifFalse: CustomBotton(
                                navigate_fun: () {
                                  if (creatrMeetKey.currentState!.validate()) {
                                    cubit.createMeet(
                                      title: titleController.text,
                                      start: timeController.text,
                                      duration: durationController.text,
                                      phone: phone,
                                    );
                                  }
                                },
                                lable: 'Create Meet',
                                fontSize: 20.sp)),
                      ],
                    ),
                  ),
                  cubit.startMeetingUrl != null
                      ? TextButton(
                          onPressed: () {
                            cubit.startMeeting(cubit.startMeetingUrl!);
                          },
                          child: Text(
                            'Start Meeting',
                            style: TextStyles.lightBlue16blod,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
