import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';

class EnhancedNavigationItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showDivider;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final int? badgeCount;
  final bool isLoading;

  const EnhancedNavigationItem({
    super.key,
    required this.label,
    required this.icon,
    this.route,
    this.onTap,
    this.isSelected = false,
    this.showDivider = true,
    this.trailing,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.badgeCount,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Container(
              height: 1.h,
              width: MediaQuery.sizeOf(context).width - 35.w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(31, 99, 99, 99),
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: backgroundColor ??
                (isSelected
                    ? Colours.LightBlue.withValues(alpha: 0.15)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? Border.all(
                    color: Colours.LightBlue.withValues(alpha: 0.3), width: 1.w)
                : null,
          ),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            title: Text(
              label,
              style: TextStyles.lightBlue16blod.copyWith(
                color: textColor ??
                    (isSelected ? Colours.DarkBlue : Colours.LightBlue),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            leading: Stack(
              children: [
                Icon(
                  icon,
                  size: 24.h,
                  color: iconColor ??
                      (isSelected ? Colours.DarkBlue : Colours.LightBlue),
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.w,
                        minHeight: 16.h,
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.w,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        iconColor ?? Colours.LightBlue,
                      ),
                    ),
                  )
                : trailing,
            onTap: isLoading
                ? null
                : () {
                    if (onTap != null) {
                      onTap!();
                    } else if (route != null) {
                      Navigator.pushNamed(context, route!);
                    }
                    // Close drawer after navigation
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }
}
