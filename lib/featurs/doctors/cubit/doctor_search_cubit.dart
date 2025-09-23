import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../constants/api_constants/api_constant.dart';
import '../models/doctor_model.dart';

part 'doctor_search_state.dart';

class DoctorSearchCubit extends Cubit<DoctorSearchState> {
  DoctorSearchCubit() : super(DoctorSearchInitial());

  final Dio _dio = Dio();
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  DoctorFilterOptions _currentFilters = const DoctorFilterOptions();

  List<Doctor> get doctors => _filteredDoctors;
  DoctorFilterOptions get currentFilters => _currentFilters;

  /// Load all doctors from API
  Future<void> loadDoctors() async {
    emit(DoctorSearchLoading());

    try {
      final response = await _dio.get('${baseUrl}Doctors/GetAllDoctors');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _allDoctors = data.map((json) => Doctor.fromJson(json)).toList();
        _filteredDoctors = List.from(_allDoctors);

        emit(DoctorSearchSuccess(
          doctors: _filteredDoctors,
          totalCount: _filteredDoctors.length,
        ));
      } else {
        emit(DoctorSearchError(
            'Failed to load doctors: ${response.statusCode}'));
      }
    } catch (e) {
      log('Error loading doctors: $e');
      emit(DoctorSearchError('Error loading doctors: ${e.toString()}'));
    }
  }

  /// Search doctors by query
  Future<void> searchDoctors(String query) async {
    try {
      if (query.isEmpty) {
        _filteredDoctors = List.from(_allDoctors);
      } else {
        _filteredDoctors = _allDoctors.where((doctor) {
          return doctor.name.toLowerCase().contains(query.toLowerCase()) ||
              doctor.specialty.toLowerCase().contains(query.toLowerCase()) ||
              doctor.description.toLowerCase().contains(query.toLowerCase()) ||
              doctor.location.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }

      emit(DoctorSearchSuccess(
        doctors: _filteredDoctors,
        totalCount: _filteredDoctors.length,
      ));
    } catch (e) {
      log('Error searching doctors: $e');
      emit(DoctorSearchError('Error searching doctors: ${e.toString()}'));
    }
  }

  /// Apply filters to doctors
  Future<void> applyFilters(DoctorFilterOptions filters) async {
    try {
      _currentFilters = filters;

      _filteredDoctors = _allDoctors.where((doctor) {
        // Specialty filter
        if (filters.specialty != null &&
            filters.specialty!.isNotEmpty &&
            !doctor.specialty
                .toLowerCase()
                .contains(filters.specialty!.toLowerCase())) {
          return false;
        }

        // Rating filter
        if (filters.minRating != null && doctor.rating < filters.minRating!) {
          return false;
        }

        // Price filters
        if (filters.minPrice != null &&
            doctor.consultationPrice < filters.minPrice!) {
          return false;
        }
        if (filters.maxPrice != null &&
            doctor.consultationPrice > filters.maxPrice!) {
          return false;
        }

        // Language filter
        if (filters.languages != null &&
            filters.languages!.isNotEmpty &&
            !filters.languages!
                .any((lang) => doctor.languages.contains(lang))) {
          return false;
        }

        // Experience filter
        if (filters.minExperienceYears != null &&
            doctor.experienceYears < filters.minExperienceYears!) {
          return false;
        }

        // Location filter
        if (filters.location != null &&
            filters.location!.isNotEmpty &&
            !doctor.location
                .toLowerCase()
                .contains(filters.location!.toLowerCase())) {
          return false;
        }

        // Availability filter
        if (filters.isAvailable != null &&
            doctor.isAvailable != filters.isAvailable!) {
          return false;
        }

        // Available days filter
        if (filters.availableDays != null &&
            filters.availableDays!.isNotEmpty &&
            !filters.availableDays!
                .any((day) => doctor.availableDays.contains(day))) {
          return false;
        }

        return true;
      }).toList();

      emit(DoctorSearchSuccess(
        doctors: _filteredDoctors,
        totalCount: _filteredDoctors.length,
      ));
    } catch (e) {
      log('Error applying filters: $e');
      emit(DoctorSearchError('Error applying filters: ${e.toString()}'));
    }
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    _currentFilters = const DoctorFilterOptions();
    _filteredDoctors = List.from(_allDoctors);

    emit(DoctorSearchSuccess(
      doctors: _filteredDoctors,
      totalCount: _filteredDoctors.length,
    ));
  }

  /// Sort doctors by different criteria
  Future<void> sortDoctors(DoctorSortOption sortOption) async {
    switch (sortOption) {
      case DoctorSortOption.ratingHighToLow:
        _filteredDoctors.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case DoctorSortOption.ratingLowToHigh:
        _filteredDoctors.sort((a, b) => a.rating.compareTo(b.rating));
        break;
      case DoctorSortOption.priceHighToLow:
        _filteredDoctors
            .sort((a, b) => b.consultationPrice.compareTo(a.consultationPrice));
        break;
      case DoctorSortOption.priceLowToHigh:
        _filteredDoctors
            .sort((a, b) => a.consultationPrice.compareTo(b.consultationPrice));
        break;
      case DoctorSortOption.experienceHighToLow:
        _filteredDoctors
            .sort((a, b) => b.experienceYears.compareTo(a.experienceYears));
        break;
      case DoctorSortOption.experienceLowToHigh:
        _filteredDoctors
            .sort((a, b) => a.experienceYears.compareTo(b.experienceYears));
        break;
      case DoctorSortOption.nameAtoZ:
        _filteredDoctors.sort((a, b) => a.name.compareTo(b.name));
        break;
      case DoctorSortOption.nameZtoA:
        _filteredDoctors.sort((a, b) => b.name.compareTo(a.name));
        break;
    }

    emit(DoctorSearchSuccess(
      doctors: _filteredDoctors,
      totalCount: _filteredDoctors.length,
    ));
  }

  /// Get available specialties
  List<String> getAvailableSpecialties() {
    return _allDoctors.map((doctor) => doctor.specialty).toSet().toList();
  }

  /// Get available locations
  List<String> getAvailableLocations() {
    return _allDoctors.map((doctor) => doctor.location).toSet().toList();
  }

  /// Get available languages
  List<String> getAvailableLanguages() {
    final Set<String> languages = {};
    for (final doctor in _allDoctors) {
      languages.addAll(doctor.languages);
    }
    return languages.toList();
  }
}

enum DoctorSortOption {
  ratingHighToLow,
  ratingLowToHigh,
  priceHighToLow,
  priceLowToHigh,
  experienceHighToLow,
  experienceLowToHigh,
  nameAtoZ,
  nameZtoA,
}
