import 'package:cached_network_image/cached_network_image.dart';
import 'package:dr_sami/constants/api_constants/api_constant.dart';
import 'package:dr_sami/core/extensions/media_values.dart';
import 'package:dr_sami/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService.instance;
    final userImage = authService.currentUserImage;
    final userName = authService.currentUserName;
    final userEmail = authService.currentUserEmail;

    return Container(
      width: context.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.r)),
        color: Colours.DarkBlue,
        image: const DecorationImage(
          image: AssetImage('assets/images/pngegg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image Section
            if (userImage != null) ...[
              CircleAvatar(
                radius: 60.r,
                backgroundColor: Colours.White,
                child: ClipOval(
                  child: CachedNetworkImage(
                    width: 120.w,
                    height: 120.w,
                    fit: BoxFit.cover,
                    imageUrl: '$imageUrl$userImage',
                    placeholder: (context, url) => CircularProgressIndicator(
                      color: Colours.White,
                    ),
                    errorWidget: (context, url, error) => _buildDefaultAvatar(),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ] else ...[
              _buildDefaultAvatar(),
              SizedBox(height: 12.h),
            ],

            // User Info Section
            if (userName != null || userEmail != null) ...[
              if (userName != null)
                Text(
                  userName,
                  style: TextStyles.white20blod,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (userName != null && userEmail != null) SizedBox(height: 2.h),
              if (userEmail != null)
                Text(
                  userEmail,
                  style: TextStyles.white16blod.copyWith(
                    color: Colours.White.withValues(alpha: 0.8),
                    fontSize: 14.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 60.r,
      backgroundColor: Colours.White.withValues(alpha: 0.2),
      child: Image.asset(
        'assets/images/account.png',
        fit: BoxFit.contain,
        width: 100.w,
        height: 100.w,
        color: Colours.White,
      ),
    );
  }
}
