import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../models/doctor_model.dart';

class DoctorFilterBottomSheet extends StatefulWidget {
  final DoctorFilterOptions currentFilters;
  final List<String> availableSpecialties;
  final List<String> availableLocations;
  final List<String> availableLanguages;
  final Function(DoctorFilterOptions) onApplyFilters;

  const DoctorFilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.availableSpecialties,
    required this.availableLocations,
    required this.availableLanguages,
    required this.onApplyFilters,
  });

  @override
  State<DoctorFilterBottomSheet> createState() =>
      _DoctorFilterBottomSheetState();
}

class _DoctorFilterBottomSheetState extends State<DoctorFilterBottomSheet> {
  late DoctorFilterOptions _filters;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _minRatingController = TextEditingController();
  final TextEditingController _minExperienceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _filters = widget.currentFilters;
    _initializeControllers();
  }

  void _initializeControllers() {
    _minPriceController.text = _filters.minPrice?.toString() ?? '';
    _maxPriceController.text = _filters.maxPrice?.toString() ?? '';
    _minRatingController.text = _filters.minRating?.toString() ?? '';
    _minExperienceController.text =
        _filters.minExperienceYears?.toString() ?? '';
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minRatingController.dispose();
    _minExperienceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
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
            child: Row(
              children: [
                Text(
                  'Filter Doctors',
                  style: TextStyles.black18blod,
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: Colours.DarkBlue,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialty Filter
                  _buildFilterSection(
                    title: 'Specialty',
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: widget.availableSpecialties.map((specialty) {
                        final isSelected = _filters.specialty == specialty;
                        return FilterChip(
                          label: Text(specialty),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _filters = _filters.copyWith(
                                specialty: selected ? specialty : null,
                              );
                            });
                          },
                          selectedColor:
                              Colours.LightBlue.withValues(alpha: 0.3),
                          checkmarkColor: Colours.DarkBlue,
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Rating Filter
                  _buildFilterSection(
                    title: 'Minimum Rating',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minRatingController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'e.g., 4.0',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onChanged: (value) {
                              final rating = double.tryParse(value);
                              _filters = _filters.copyWith(
                                minRating: rating,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          'stars',
                          style: TextStyles.grey14,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Price Range Filter
                  _buildFilterSection(
                    title: 'Price Range',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Min',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onChanged: (value) {
                              final price = double.tryParse(value);
                              _filters = _filters.copyWith(
                                minPrice: price,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: TextField(
                            controller: _maxPriceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Max',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onChanged: (value) {
                              final price = double.tryParse(value);
                              _filters = _filters.copyWith(
                                maxPrice: price,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          '\$',
                          style: TextStyles.grey14,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Experience Filter
                  _buildFilterSection(
                    title: 'Minimum Experience',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _minExperienceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'e.g., 5',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            onChanged: (value) {
                              final experience = int.tryParse(value);
                              _filters = _filters.copyWith(
                                minExperienceYears: experience,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Text(
                          'years',
                          style: TextStyles.grey14,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Location Filter
                  _buildFilterSection(
                    title: 'Location',
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: widget.availableLocations.map((location) {
                        final isSelected = _filters.location == location;
                        return FilterChip(
                          label: Text(location),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _filters = _filters.copyWith(
                                location: selected ? location : null,
                              );
                            });
                          },
                          selectedColor:
                              Colours.LightBlue.withValues(alpha: 0.3),
                          checkmarkColor: Colours.DarkBlue,
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Languages Filter
                  _buildFilterSection(
                    title: 'Languages',
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: widget.availableLanguages.map((language) {
                        final isSelected =
                            _filters.languages?.contains(language) ?? false;
                        return FilterChip(
                          label: Text(language),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              final languages =
                                  List<String>.from(_filters.languages ?? []);
                              if (selected) {
                                languages.add(language);
                              } else {
                                languages.remove(language);
                              }
                              _filters = _filters.copyWith(
                                languages: languages.isEmpty ? null : languages,
                              );
                            });
                          },
                          selectedColor:
                              Colours.LightBlue.withValues(alpha: 0.3),
                          checkmarkColor: Colours.DarkBlue,
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Availability Filter
                  _buildFilterSection(
                    title: 'Availability',
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: const Text('Available Now'),
                            value: true,
                            groupValue: _filters.isAvailable,
                            onChanged: (value) {
                              setState(() {
                                _filters = _filters.copyWith(
                                  isAvailable: value,
                                );
                              });
                            },
                            activeColor: Colours.DarkBlue,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool?>(
                            title: const Text('All'),
                            value: null,
                            groupValue: _filters.isAvailable,
                            onChanged: (value) {
                              setState(() {
                                _filters = _filters.copyWith(
                                  isAvailable: value,
                                );
                              });
                            },
                            activeColor: Colours.DarkBlue,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onApplyFilters(_filters);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colours.DarkBlue,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Apply Filters',
                  style: TextStyles.white16blod,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.black16blod,
        ),
        SizedBox(height: 12.h),
        child,
      ],
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters = const DoctorFilterOptions();
      _initializeControllers();
    });
  }
}
