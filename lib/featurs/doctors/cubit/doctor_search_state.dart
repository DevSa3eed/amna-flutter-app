part of 'doctor_search_cubit.dart';

abstract class DoctorSearchState extends Equatable {
  const DoctorSearchState();

  @override
  List<Object?> get props => [];
}

class DoctorSearchInitial extends DoctorSearchState {}

class DoctorSearchLoading extends DoctorSearchState {}

class DoctorSearchSuccess extends DoctorSearchState {
  final List<Doctor> doctors;
  final int totalCount;

  const DoctorSearchSuccess({
    required this.doctors,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [doctors, totalCount];
}

class DoctorSearchError extends DoctorSearchState {
  final String message;

  const DoctorSearchError(this.message);

  @override
  List<Object?> get props => [message];
}
