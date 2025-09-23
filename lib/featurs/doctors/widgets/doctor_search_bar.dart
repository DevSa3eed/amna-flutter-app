import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';

class DoctorSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onFilterTap;

  const DoctorSearchBar({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        controller: controller,
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search doctors, specialties, locations...',
          hintStyle: TextStyles.grey14,
          prefixIcon: Icon(
            Icons.search,
            color: Colours.DarkBlue,
            size: 20.w,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    onSearchChanged('');
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey,
                    size: 20.w,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        style: TextStyles.black14,
      ),
    );
  }
}
