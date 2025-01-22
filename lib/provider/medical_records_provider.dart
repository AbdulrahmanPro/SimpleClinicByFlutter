import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/medical_records_repository.dart';
import 'package:test_provider_mvvm/model/medical_records_dto.dart';
import 'package:test_provider_mvvm/model_view/medical_records/medical_records_view_model.dart';

final medicalRecordsRepositoryProvider = Provider((ref) => MedicalRecordsRepository());

final medicalRecordsViewModelProvider =
    StateNotifierProvider<MedicalRecordsViewModel, AsyncValue<List<MedicalRecordsDTO>>>(
  (ref) => MedicalRecordsViewModel(ref.read(medicalRecordsRepositoryProvider)),
);
