import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/medical_records_repository.dart';
import 'package:test_provider_mvvm/model/medical_records_dto.dart';

class MedicalRecordsViewModel extends StateNotifier<AsyncValue<List<MedicalRecordsDTO>>> {
  final MedicalRecordsRepository repository;

  MedicalRecordsViewModel(this.repository) : super(const AsyncValue.loading()) {
    fetchMedicalRecords();
  }

  Future<void> fetchMedicalRecords() async {
    try {
      state = const AsyncValue.loading();
      final records = await repository.fetchMedicalRecords();
      state = AsyncValue.data(records);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createMedicalRecord(MedicalRecordsDTO record) async {
    try {
      state = const AsyncValue.loading();
      await repository.createMedicalRecord(record);
      fetchMedicalRecords(); // Refresh the list after creating the record
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateMedicalRecord(int id, MedicalRecordsDTO record) async {
    try {
      await repository.updateMedicalRecord(id, record);
      fetchMedicalRecords(); // Refresh the list after updating the record
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteMedicalRecord(int id) async {
    try {
      await repository.deleteMedicalRecord(id);
      fetchMedicalRecords(); // Refresh the list after deleting the record
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
