import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import 'navigation_item.dart';

class NavigationGroup extends StatelessWidget {
  final String? title;
  final List<NavigationItem> items;
  final bool showTitle;

  const NavigationGroup({
    super.key,
    this.title,
    required this.items,
    this.showTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null && showTitle)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Text(
              title!,
              style: TextStyles.lightBlue16blod.copyWith(
                color: Colours.DarkBlue.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return NavigationItem(
            label: item.label,
            icon: item.icon,
            route: item.route,
            onTap: item.onTap,
            isSelected: item.isSelected,
            showDivider: index > 0,
            trailing: item.trailing,
            iconColor: item.iconColor,
            textColor: item.textColor,
          );
        }),
        SizedBox(height: 8.h),
      ],
    );
  }
}
