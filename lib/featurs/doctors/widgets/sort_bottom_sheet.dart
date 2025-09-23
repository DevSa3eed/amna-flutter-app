import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../cubit/doctor_search_cubit.dart';

class SortBottomSheet extends StatelessWidget {
  final DoctorSortOption currentSortOption;
  final Function(DoctorSortOption) onSortSelected;

  const SortBottomSheet({
    super.key,
    required this.currentSortOption,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Sort By',
              style: TextStyles.black18blod,
            ),
          ),

          // Sort options
          ...DoctorSortOption.values.map((option) {
            return RadioListTile<DoctorSortOption>(
              title: Text(_getSortOptionTitle(option)),
              subtitle: Text(_getSortOptionSubtitle(option)),
              value: option,
              groupValue: currentSortOption,
              onChanged: (value) {
                if (value != null) {
                  onSortSelected(value);
                  Navigator.pop(context);
                }
              },
              activeColor: Colours.DarkBlue,
            );
          }).toList(),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  String _getSortOptionTitle(DoctorSortOption option) {
    switch (option) {
      case DoctorSortOption.ratingHighToLow:
        return 'Rating (High to Low)';
      case DoctorSortOption.ratingLowToHigh:
        return 'Rating (Low to High)';
      case DoctorSortOption.priceHighToLow:
        return 'Price (High to Low)';
      case DoctorSortOption.priceLowToHigh:
        return 'Price (Low to High)';
      case DoctorSortOption.experienceHighToLow:
        return 'Experience (High to Low)';
      case DoctorSortOption.experienceLowToHigh:
        return 'Experience (Low to High)';
      case DoctorSortOption.nameAtoZ:
        return 'Name (A to Z)';
      case DoctorSortOption.nameZtoA:
        return 'Name (Z to A)';
    }
  }

  String _getSortOptionSubtitle(DoctorSortOption option) {
    switch (option) {
      case DoctorSortOption.ratingHighToLow:
        return 'Show highest rated doctors first';
      case DoctorSortOption.ratingLowToHigh:
        return 'Show lowest rated doctors first';
      case DoctorSortOption.priceHighToLow:
        return 'Show most expensive consultations first';
      case DoctorSortOption.priceLowToHigh:
        return 'Show cheapest consultations first';
      case DoctorSortOption.experienceHighToLow:
        return 'Show most experienced doctors first';
      case DoctorSortOption.experienceLowToHigh:
        return 'Show least experienced doctors first';
      case DoctorSortOption.nameAtoZ:
        return 'Sort doctors alphabetically';
      case DoctorSortOption.nameZtoA:
        return 'Sort doctors reverse alphabetically';
    }
  }
}
