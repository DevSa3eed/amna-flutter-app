import 'package:equatable/equatable.dart';

/// Doctor model representing a healthcare provider
class Doctor extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final double consultationPrice;
  final List<String> languages;
  final List<String> qualifications;
  final int experienceYears;
  final String location;
  final bool isAvailable;
  final List<String> availableDays;
  final List<String> availableTimeSlots;
  final String phoneNumber;
  final String email;
  final DateTime? nextAvailableSlot;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.consultationPrice,
    required this.languages,
    required this.qualifications,
    required this.experienceYears,
    required this.location,
    required this.isAvailable,
    required this.availableDays,
    required this.availableTimeSlots,
    required this.phoneNumber,
    required this.email,
    this.nextAvailableSlot,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      specialty: json['specialty']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      consultationPrice: (json['consultationPrice'] ?? 0.0).toDouble(),
      languages: List<String>.from(json['languages'] ?? []),
      qualifications: List<String>.from(json['qualifications'] ?? []),
      experienceYears: json['experienceYears'] ?? 0,
      location: json['location']?.toString() ?? '',
      isAvailable: json['isAvailable'] ?? false,
      availableDays: List<String>.from(json['availableDays'] ?? []),
      availableTimeSlots: List<String>.from(json['availableTimeSlots'] ?? []),
      phoneNumber: json['phoneNumber']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      nextAvailableSlot: json['nextAvailableSlot'] != null
          ? DateTime.parse(json['nextAvailableSlot'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'consultationPrice': consultationPrice,
      'languages': languages,
      'qualifications': qualifications,
      'experienceYears': experienceYears,
      'location': location,
      'isAvailable': isAvailable,
      'availableDays': availableDays,
      'availableTimeSlots': availableTimeSlots,
      'phoneNumber': phoneNumber,
      'email': email,
      'nextAvailableSlot': nextAvailableSlot?.toIso8601String(),
    };
  }

  Doctor copyWith({
    String? id,
    String? name,
    String? specialty,
    String? description,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    double? consultationPrice,
    List<String>? languages,
    List<String>? qualifications,
    int? experienceYears,
    String? location,
    bool? isAvailable,
    List<String>? availableDays,
    List<String>? availableTimeSlots,
    String? phoneNumber,
    String? email,
    DateTime? nextAvailableSlot,
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      consultationPrice: consultationPrice ?? this.consultationPrice,
      languages: languages ?? this.languages,
      qualifications: qualifications ?? this.qualifications,
      experienceYears: experienceYears ?? this.experienceYears,
      location: location ?? this.location,
      isAvailable: isAvailable ?? this.isAvailable,
      availableDays: availableDays ?? this.availableDays,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      nextAvailableSlot: nextAvailableSlot ?? this.nextAvailableSlot,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        specialty,
        description,
        imageUrl,
        rating,
        reviewCount,
        consultationPrice,
        languages,
        qualifications,
        experienceYears,
        location,
        isAvailable,
        availableDays,
        availableTimeSlots,
        phoneNumber,
        email,
        nextAvailableSlot,
      ];
}

/// Filter options for doctor search
class DoctorFilterOptions extends Equatable {
  final String? specialty;
  final double? minRating;
  final double? maxPrice;
  final double? minPrice;
  final List<String>? languages;
  final int? minExperienceYears;
  final String? location;
  final bool? isAvailable;
  final List<String>? availableDays;

  const DoctorFilterOptions({
    this.specialty,
    this.minRating,
    this.maxPrice,
    this.minPrice,
    this.languages,
    this.minExperienceYears,
    this.location,
    this.isAvailable,
    this.availableDays,
  });

  DoctorFilterOptions copyWith({
    String? specialty,
    double? minRating,
    double? maxPrice,
    double? minPrice,
    List<String>? languages,
    int? minExperienceYears,
    String? location,
    bool? isAvailable,
    List<String>? availableDays,
  }) {
    return DoctorFilterOptions(
      specialty: specialty ?? this.specialty,
      minRating: minRating ?? this.minRating,
      maxPrice: maxPrice ?? this.maxPrice,
      minPrice: minPrice ?? this.minPrice,
      languages: languages ?? this.languages,
      minExperienceYears: minExperienceYears ?? this.minExperienceYears,
      location: location ?? this.location,
      isAvailable: isAvailable ?? this.isAvailable,
      availableDays: availableDays ?? this.availableDays,
    );
  }

  @override
  List<Object?> get props => [
        specialty,
        minRating,
        maxPrice,
        minPrice,
        languages,
        minExperienceYears,
        location,
        isAvailable,
        availableDays,
      ];
}

/// Search result wrapper
class DoctorSearchResult extends Equatable {
  final List<Doctor> doctors;
  final int totalCount;
  final bool hasMore;

  const DoctorSearchResult({
    required this.doctors,
    required this.totalCount,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [doctors, totalCount, hasMore];
}
