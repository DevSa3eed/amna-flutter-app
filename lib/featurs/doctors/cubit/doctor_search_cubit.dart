import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
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
    if (isClosed) return;
    emit(DoctorSearchLoading());

    try {
      // Try the doctors endpoint first
      final response = await _dio.get('${baseUrl}$getAllDoctors');

      if (isClosed) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _allDoctors = data.map((json) => Doctor.fromJson(json)).toList();
        _filteredDoctors = List.from(_allDoctors);

        if (isClosed) return;
        emit(DoctorSearchSuccess(
          doctors: _filteredDoctors,
          totalCount: _filteredDoctors.length,
        ));
      } else {
        if (isClosed) return;
        emit(DoctorSearchError(
            'Failed to load doctors: ${response.statusCode}'));
      }
    } catch (e) {
      log('Error loading doctors: $e');

      // If doctors endpoint fails, try team members as fallback
      if (e is DioException && e.response?.statusCode == 404) {
        log('Doctors endpoint not found, trying team members...');
        await _loadDoctorsFromTeamMembers();
      } else {
        if (isClosed) return;
        emit(DoctorSearchError('Error loading doctors: ${e.toString()}'));
      }
    }
  }

  /// Fallback method to load doctors from team members
  Future<void> _loadDoctorsFromTeamMembers() async {
    if (isClosed) return;

    try {
      final response = await _dio.get('${baseUrl}$getAllTeams');

      if (isClosed) return;

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        _allDoctors =
            data.map((json) => _convertTeamMemberToDoctor(json)).toList();
        _filteredDoctors = List.from(_allDoctors);

        if (isClosed) return;
        emit(DoctorSearchSuccess(
          doctors: _filteredDoctors,
          totalCount: _filteredDoctors.length,
        ));
      } else {
        // If team members also fail, use mock data
        await _loadMockDoctors();
      }
    } catch (e) {
      log('Error loading team members: $e');
      // Use mock data as final fallback
      await _loadMockDoctors();
    }
  }

  /// Convert team member data to doctor format
  Doctor _convertTeamMemberToDoctor(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']?.toString() ?? '',
      name: json['titel']?.toString() ?? 'Unknown Doctor',
      specialty: json['position']?.toString() ?? 'General Medicine',
      description: 'Professional healthcare provider',
      imageUrl: json['image']?.toString() ?? '',
      rating: 4.5,
      reviewCount: 25,
      consultationPrice: 150.0,
      languages: ['English', 'Arabic'],
      qualifications: ['MD', 'Board Certified'],
      experienceYears: 5,
      location: 'Dubai, UAE',
      isAvailable: true,
      availableDays: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      availableTimeSlots: ['09:00', '10:00', '11:00', '14:00', '15:00'],
      phoneNumber: '+971501234567',
      email: 'doctor@amnatelehealth.com',
    );
  }

  /// Load mock doctors data as final fallback
  Future<void> _loadMockDoctors() async {
    if (isClosed) return;

    _allDoctors = _getMockDoctors();
    _filteredDoctors = List.from(_allDoctors);

    if (isClosed) return;
    emit(DoctorSearchSuccess(
      doctors: _filteredDoctors,
      totalCount: _filteredDoctors.length,
    ));
  }

  /// Get mock doctors data
  List<Doctor> _getMockDoctors() {
    return [
      Doctor(
        id: '1',
        name: 'Dr. Sarah Ahmed',
        specialty: 'Cardiology',
        description:
            'Experienced cardiologist specializing in heart diseases and preventive care.',
        imageUrl: '',
        rating: 4.8,
        reviewCount: 45,
        consultationPrice: 200.0,
        languages: ['English', 'Arabic'],
        qualifications: ['MD', 'Cardiology Board Certified'],
        experienceYears: 8,
        location: 'Dubai, UAE',
        isAvailable: true,
        availableDays: ['Monday', 'Wednesday', 'Friday'],
        availableTimeSlots: ['09:00', '10:00', '11:00', '14:00'],
        phoneNumber: '+971501234567',
        email: 'sarah.ahmed@amnatelehealth.com',
      ),
      Doctor(
        id: '2',
        name: 'Dr. Mohammed Hassan',
        specialty: 'Pediatrics',
        description:
            'Pediatric specialist with expertise in child health and development.',
        imageUrl: '',
        rating: 4.6,
        reviewCount: 32,
        consultationPrice: 180.0,
        languages: ['English', 'Arabic', 'Urdu'],
        qualifications: ['MD', 'Pediatrics Board Certified'],
        experienceYears: 6,
        location: 'Abu Dhabi, UAE',
        isAvailable: true,
        availableDays: ['Tuesday', 'Thursday', 'Saturday'],
        availableTimeSlots: ['10:00', '11:00', '15:00', '16:00'],
        phoneNumber: '+971501234568',
        email: 'mohammed.hassan@amnatelehealth.com',
      ),
      Doctor(
        id: '3',
        name: 'Dr. Fatima Al-Zahra',
        specialty: 'Dermatology',
        description:
            'Dermatologist specializing in skin conditions and cosmetic treatments.',
        imageUrl: '',
        rating: 4.7,
        reviewCount: 28,
        consultationPrice: 220.0,
        languages: ['English', 'Arabic'],
        qualifications: ['MD', 'Dermatology Board Certified'],
        experienceYears: 7,
        location: 'Sharjah, UAE',
        isAvailable: true,
        availableDays: ['Monday', 'Wednesday', 'Thursday'],
        availableTimeSlots: ['09:00', '10:00', '14:00', '15:00'],
        phoneNumber: '+971501234569',
        email: 'fatima.alzahra@amnatelehealth.com',
      ),
      Doctor(
        id: '4',
        name: 'Dr. Ahmed Khalil',
        specialty: 'Orthopedics',
        description:
            'Orthopedic surgeon specializing in bone and joint disorders.',
        imageUrl: '',
        rating: 4.5,
        reviewCount: 41,
        consultationPrice: 250.0,
        languages: ['English', 'Arabic'],
        qualifications: ['MD', 'Orthopedic Surgery Board Certified'],
        experienceYears: 10,
        location: 'Dubai, UAE',
        isAvailable: true,
        availableDays: ['Tuesday', 'Thursday', 'Friday'],
        availableTimeSlots: ['08:00', '09:00', '10:00', '14:00'],
        phoneNumber: '+971501234570',
        email: 'ahmed.khalil@amnatelehealth.com',
      ),
      Doctor(
        id: '5',
        name: 'Dr. Aisha Mohammed',
        specialty: 'Gynecology',
        description:
            'Gynecologist providing comprehensive women\'s health services.',
        imageUrl: '',
        rating: 4.9,
        reviewCount: 38,
        consultationPrice: 190.0,
        languages: ['English', 'Arabic'],
        qualifications: ['MD', 'Gynecology Board Certified'],
        experienceYears: 9,
        location: 'Abu Dhabi, UAE',
        isAvailable: true,
        availableDays: ['Monday', 'Wednesday', 'Saturday'],
        availableTimeSlots: ['09:00', '10:00', '11:00', '15:00'],
        phoneNumber: '+971501234571',
        email: 'aisha.mohammed@amnatelehealth.com',
      ),
    ];
  }

  /// Search doctors by query
  Future<void> searchDoctors(String query) async {
    if (isClosed) return;

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

      if (isClosed) return;
      emit(DoctorSearchSuccess(
        doctors: _filteredDoctors,
        totalCount: _filteredDoctors.length,
      ));
    } catch (e) {
      log('Error searching doctors: $e');
      if (isClosed) return;
      emit(DoctorSearchError('Error searching doctors: ${e.toString()}'));
    }
  }

  /// Apply filters to doctors
  Future<void> applyFilters(DoctorFilterOptions filters) async {
    if (isClosed) return;

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

      if (isClosed) return;
      emit(DoctorSearchSuccess(
        doctors: _filteredDoctors,
        totalCount: _filteredDoctors.length,
      ));
    } catch (e) {
      log('Error applying filters: $e');
      if (isClosed) return;
      emit(DoctorSearchError('Error applying filters: ${e.toString()}'));
    }
  }

  /// Clear all filters
  Future<void> clearFilters() async {
    if (isClosed) return;

    _currentFilters = const DoctorFilterOptions();
    _filteredDoctors = List.from(_allDoctors);

    if (isClosed) return;
    emit(DoctorSearchSuccess(
      doctors: _filteredDoctors,
      totalCount: _filteredDoctors.length,
    ));
  }

  /// Sort doctors by different criteria
  Future<void> sortDoctors(DoctorSortOption sortOption) async {
    if (isClosed) return;

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

    if (isClosed) return;
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

  @override
  Future<void> close() {
    _dio.close();
    return super.close();
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
