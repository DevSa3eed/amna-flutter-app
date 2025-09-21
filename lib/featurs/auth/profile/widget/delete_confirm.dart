import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/profile/cubit/profile_cubit.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/config.dart';
import '../../../../core/theme/Colors/coluors.dart';
import '../../../../routes/routes.dart';

void ConfirmaitionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colours.White,
        title: Row(
          children: [
            Icon(
              Icons.delete,
              color: Colours.DarkBlue,
            ),
            Text(
              config.localization['deleteAccount'],
              style: TextStyles.lightBlue20blod,
            ),
          ],
        ),
        content: Text(config.localization['confirmDelete']),
        actions: [
          TextButton(
            child: Text(
              config.localization['close'],
              style: TextStyle(color: Colours.DarkBlue),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          BlocProvider(
            create: (context) => UserProfileCubit(),
            child: BlocConsumer<UserProfileCubit, userProfileState>(
              listener: (context, state) {
                if (state is DeleteProfilesuccess) {
                  showToast(content: state.message);
                  Navigator.pushNamed(context, Routes.homeRoute);
                } else if (state is DeleteProfileFailed) {
                  showToast(content: state.message);
                }
              },
              builder: (context, state) {
                return ConditionBuilder(
                  condition: state is DeleteProfileLoading,
                  ifFalse: TextButton(
                    child: Text(
                      config.localization['deleteAccount'],
                      style: TextStyle(color: Colours.DarkBlue),
                    ),
                    onPressed: () {
                      context.read<UserProfileCubit>().deleteUser();
                      // Close the dialog
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    },
  );
}
