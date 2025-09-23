import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/constants/cached_constants/cached_constants.dart';
import 'package:dr_sami/core/config/config.dart';
import 'package:dr_sami/core/theme/Colors/coluors.dart';
import 'package:dr_sami/core/theme/text_styles/text_styeles.dart';
import 'package:dr_sami/featurs/auth/profile/cubit/profile_cubit.dart';
import 'package:dr_sami/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.White,
      appBar: AppBar(
        title: Text(
          config.localization['profile'],
          style: TextStyles.lightBlue20blod,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.updateProfileRoute);
            },
            icon: Icon(
              IconlyBroken.edit,
              color: Colours.DarkBlue,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30.h),
            // Profile Picture
            CircleAvatar(
              radius: 80.r,
              backgroundColor: Colours.LightBlue,
              child: image != null
                  ? ClipOval(
                      child: CachedNetworkImage(
                        width: 160.w,
                        height: 160.h,
                        fit: BoxFit.cover,
                        imageUrl: '$imageUrl$image',
                        placeholder: (context, url) =>
                            CircularProgressIndicator(
                          color: Colours.DarkBlue,
                        ),
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 80.w,
                          color: Colours.White,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 80.w,
                      color: Colours.White,
                    ),
            ),
            SizedBox(height: 20.h),
            // User Name
            Text(
              name ?? 'User',
              style: TextStyles.lightBlue24blod,
            ),
            SizedBox(height: 5.h),
            // Email
            Text(
              userEmail ?? 'No email',
              style: TextStyles.gray15blod,
            ),
            SizedBox(height: 30.h),
            // Profile Information Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: IconlyBroken.profile,
                    label: 'Username',
                    value: username ?? 'Not set',
                  ),
                  SizedBox(height: 15.h),
                  _buildInfoRow(
                    icon: IconlyBroken.message,
                    label: 'Email',
                    value: userEmail ?? 'Not set',
                  ),
                  SizedBox(height: 15.h),
                  _buildInfoRow(
                    icon: IconlyBroken.call,
                    label: 'Phone',
                    value: phone ?? 'Not set',
                  ),
                  SizedBox(height: 15.h),
                  _buildInfoRow(
                    icon: IconlyBroken.shield_done,
                    label: 'Account Type',
                    value: isAdmin == true ? 'Admin' : 'User',
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            // Action Buttons
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  // Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.updateProfileRoute);
                      },
                      icon: Icon(IconlyBroken.edit, color: Colors.white),
                      label: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colours.DarkBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      icon: Icon(IconlyBroken.logout, color: Colors.white),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colours.DarkBlue,
          size: 20.w,
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colours.DarkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<UserProfileCubit>().logOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  Routes.loginRoute,
                  (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
