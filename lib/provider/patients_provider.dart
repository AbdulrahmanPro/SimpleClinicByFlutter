import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/patients_repository.dart';
import 'package:test_provider_mvvm/data/repositories/person_repository.dart';
import 'package:test_provider_mvvm/model/patient_all_info_dto.dart';
import 'package:test_provider_mvvm/model_view/patients/patients_view_model.dart';

/// Provider for PatientRepository
final patientRepositoryProvider = Provider<PatientRepository>((ref) {
  return PatientRepository();
});

/// Provider for PersonRepository
final personRepositoryProvider = Provider<PersonRepository>((ref) {
  return PersonRepository();
});

/// Provider for PatientViewModel
final patientViewModelProvider = StateNotifierProvider<PatientViewModel,
    AsyncValue<List<PatientAllInfoDTO>>>((ref) {
  final patientRepository = ref.read(patientRepositoryProvider);
  final personRepository = ref.read(personRepositoryProvider);
  return PatientViewModel(patientRepository, personRepository);
});
