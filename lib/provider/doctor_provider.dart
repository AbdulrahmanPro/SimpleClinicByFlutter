import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/doctors_repository.dart';
import 'package:test_provider_mvvm/model/all_doctors_info_dto.dart';
import 'package:test_provider_mvvm/model_view/doctors/doctors_view_model.dart';
import 'package:test_provider_mvvm/provider/person_provider.dart';

final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  return DoctorRepository();
});

final doctorViewModelProvider =
    StateNotifierProvider<DoctorViewModel, AsyncValue<List<AllDoctorsInfoDTO>>>(
        (ref) {
  final doctorRepository = ref.read(doctorRepositoryProvider);
  final personRepository = ref.read(personRepositoryProvider);
  return DoctorViewModel(personRepository, doctorRepository);
});
