import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/Colors/coluors.dart';
import '../../../core/theme/text_styles/text_styeles.dart';
import '../cubit/doctor_search_cubit.dart';
import '../models/doctor_model.dart';
import '../widgets/doctor_card.dart';
import '../widgets/doctor_filter_bottom_sheet.dart';
import '../widgets/doctor_search_bar.dart';
import '../widgets/sort_bottom_sheet.dart';

class DoctorSearchScreen extends StatefulWidget {
  const DoctorSearchScreen({super.key});

  @override
  State<DoctorSearchScreen> createState() => _DoctorSearchScreenState();
}

class _DoctorSearchScreenState extends State<DoctorSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  DoctorSortOption _currentSortOption = DoctorSortOption.ratingHighToLow;

  @override
  void initState() {
    super.initState();
    context.read<DoctorSearchCubit>().loadDoctors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.White,
      appBar: AppBar(
        title: Text(
          'Find Doctors',
          style: TextStyles.lightBlue20blod,
        ),
        backgroundColor: Colours.White,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: Icon(
              Icons.filter_list,
              color: Colours.DarkBlue,
            ),
          ),
          IconButton(
            onPressed: _showSortBottomSheet,
            icon: Icon(
              Icons.sort,
              color: Colours.DarkBlue,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: DoctorSearchBar(
              controller: _searchController,
              onSearchChanged: (query) {
                context.read<DoctorSearchCubit>().searchDoctors(query);
              },
            ),
          ),

          // Results
          Expanded(
            child: BlocConsumer<DoctorSearchCubit, DoctorSearchState>(
              listener: (context, state) {
                if (state is DoctorSearchError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is DoctorSearchLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is DoctorSearchError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.w,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error loading doctors',
                          style: TextStyles.black18blod,
                        ),
                        SizedBox(height: 8.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<DoctorSearchCubit>().loadDoctors();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is DoctorSearchSuccess) {
                  if (state.doctors.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80.w,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 24.h),
                            Text(
                              'No doctors found',
                              style: TextStyles.black14blod,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              _getEmptyStateMessage(),
                              style: TextStyles.grey14,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    _searchController.clear();
                                    context
                                        .read<DoctorSearchCubit>()
                                        .searchDoctors('');
                                  },
                                  icon: const Icon(Icons.clear),
                                  label: const Text('Clear Search'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colours.LightBlue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<DoctorSearchCubit>()
                                        .clearFilters();
                                    _searchController.clear();
                                  },
                                  icon: const Icon(Icons.filter_alt_off),
                                  label: const Text('Clear Filters'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colours.DarkBlue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      // Results count
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Text(
                              '${state.totalCount} doctors found',
                              style: TextStyles.grey14,
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                context
                                    .read<DoctorSearchCubit>()
                                    .clearFilters();
                                _searchController.clear();
                              },
                              child: Text(
                                'Clear filters',
                                style: TextStyle(
                                  color: Colours.DarkBlue,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Doctors list
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: state.doctors.length,
                          itemBuilder: (context, index) {
                            final doctor = state.doctors[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: DoctorCard(
                                doctor: doctor,
                                onTap: () {
                                  // Navigate to doctor details
                                  _navigateToDoctorDetails(doctor);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DoctorFilterBottomSheet(
        currentFilters: context.read<DoctorSearchCubit>().currentFilters,
        availableSpecialties:
            context.read<DoctorSearchCubit>().getAvailableSpecialties(),
        availableLocations:
            context.read<DoctorSearchCubit>().getAvailableLocations(),
        availableLanguages:
            context.read<DoctorSearchCubit>().getAvailableLanguages(),
        onApplyFilters: (filters) {
          context.read<DoctorSearchCubit>().applyFilters(filters);
        },
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheet(
        currentSortOption: _currentSortOption,
        onSortSelected: (sortOption) {
          setState(() {
            _currentSortOption = sortOption;
          });
          context.read<DoctorSearchCubit>().sortDoctors(sortOption);
        },
      ),
    );
  }

  String _getEmptyStateMessage() {
    final cubit = context.read<DoctorSearchCubit>();
    final hasSearchQuery = _searchController.text.isNotEmpty;
    final hasFilters = cubit.currentFilters != const DoctorFilterOptions();

    if (hasSearchQuery && hasFilters) {
      return 'No doctors match your search "${_searchController.text}" and current filters. Try adjusting your search terms or filters.';
    } else if (hasSearchQuery) {
      return 'No doctors found for "${_searchController.text}". Try different search terms or check the spelling.';
    } else if (hasFilters) {
      return 'No doctors match your current filters. Try adjusting or clearing your filters.';
    } else {
      return 'No doctors are available at the moment. Please try again later or contact support.';
    }
  }

  void _navigateToDoctorDetails(Doctor doctor) {
    // TODO: Navigate to doctor details screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Doctor details for ${doctor.name}'),
        backgroundColor: Colours.DarkBlue,
      ),
    );
  }
}
