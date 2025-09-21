import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/gestures/optimized_gesture_detector.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';

class NavigationItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? route;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showDivider;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;

  const NavigationItem({
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
          decoration: BoxDecoration(
            color: isSelected
                ? Colours.LightBlue.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: OptimizedInkWell(
            onTap: () {
              if (onTap != null) {
                onTap!();
              } else if (route != null) {
                Navigator.pushNamed(context, route!);
                // Close drawer after navigation
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              }
            },
            borderRadius: BorderRadius.circular(8.r),
            child: ListTile(
              title: Text(
                label,
                style: TextStyles.lightBlue16blod.copyWith(
                  color: textColor ??
                      (isSelected ? Colours.DarkBlue : Colours.LightBlue),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              leading: Icon(
                icon,
                size: 24.h,
                color: iconColor ??
                    (isSelected ? Colours.DarkBlue : Colours.LightBlue),
              ),
              trailing: trailing,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
