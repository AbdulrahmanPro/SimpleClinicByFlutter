import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/prescriptions_repository.dart';
import 'package:test_provider_mvvm/model/prescriptions_dto.dart';

class PrescriptionsViewModel
    extends StateNotifier<AsyncValue<List<PrescriptionsDTO>>> {
  final PrescriptionsRepository repository;

  PrescriptionsViewModel(this.repository) : super(const AsyncValue.loading()) {
    fetchPrescriptions();
  }

  Future<void> fetchPrescriptions() async {
    try {
      state = const AsyncValue.loading();
      final prescriptions = await repository.fetchPrescriptions();
      state = AsyncValue.data(prescriptions);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createPrescription(PrescriptionsDTO prescription) async {
    try {
      state = const AsyncValue.loading();
      await repository.createPrescription(prescription);
      fetchPrescriptions(); // Refresh the list after creating the prescription
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updatePrescription(int id, PrescriptionsDTO prescription) async {
    try {
      await repository.updatePrescription(id, prescription);
      fetchPrescriptions(); // Refresh the list after updating the prescription
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deletePrescription(int id) async {
    try {
      await repository.deletePrescription(id);
      fetchPrescriptions(); // Refresh the list after deleting the prescription
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
