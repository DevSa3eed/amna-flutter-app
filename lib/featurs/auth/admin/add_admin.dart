import 'package:dr_sami/core/constant_widgets/toast.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/admin/cubit/add_admin_cubit.dart';
import 'package:dr_sami/featurs/auth/widgets/custom_button.dart';
import 'package:dr_sami/featurs/auth/widgets/textField.dart';
import 'package:dr_sami/featurs/home_screen/widgets/condition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

import '../../../core/config/config.dart';

class AddAdmin extends StatelessWidget {
  const AddAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    GlobalKey<FormState> adminKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colours.White,
      appBar: AppBar(
        title: Text(
          config.localization['addadmin'],
          style: TextStyles.lightBlue20blod,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/admin.jpeg'),
            Form(
              key: adminKey,
              child: Column(
                children: [
                  CustomTextFeild(
                    controller: usernameController,
                    label: config.localization['username'],
                    isPassword: false,
                    iconPre: IconlyLight.add_user,
                    type: TextInputType.text,
                  ),
                  BlocProvider(
                    create: (context) => AddAdminCubit(),
                    child: BlocConsumer<AddAdminCubit, AddAdminState>(
                      listener: (context, state) {
                        if (state is AddAdminSuccess) {
                          showToast(content: state.message);
                        } else if (state is AddAdminFailed) {
                          showToast(content: state.message);
                        }
                      },
                      builder: (context, state) {
                        return ConditionBuilder(
                          condition: state is AddAdminLoading,
                          ifFalse: CustomBotton(
                            navigate_fun: () {
                              if (adminKey.currentState!.validate()) {
                                context.read<AddAdminCubit>().addAdmin(
                                    username: usernameController.text);
                              }
                            },
                            lable: config.localization['addadmin'],
                            fontSize: 20.sp,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
