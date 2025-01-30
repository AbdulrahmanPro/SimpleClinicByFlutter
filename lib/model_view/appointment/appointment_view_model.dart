import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/appointment_repository.dart';
import 'package:test_provider_mvvm/model/all_doctors_info_dto.dart';
import 'package:test_provider_mvvm/model/apointment.dart';
import 'package:test_provider_mvvm/model/apointment_dto.dart';
import 'package:test_provider_mvvm/model/patient_all_info_dto.dart';

class AppointmentViewModel
    extends StateNotifier<AsyncValue<List<AppointmentDTO>>> {
  final AppointmentRepository repository;

  AppointmentViewModel(this.repository) : super(const AsyncValue.loading()) {
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    try {
      state = const AsyncValue.loading();
      final appointments = await repository.fetchAppointments();
      state = AsyncValue.data(appointments);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      await repository.deleteAppointment(id);
      fetchAppointments(); // Refresh the appointments list after delete
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<PatientAllInfoDTO>> searchPersons(String query) async {
    try {
      final persons = await repository.fetchAllPatients();
      return persons
          .where((person) =>
              person.personName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search persons: $e');
    }
  }

  Future<void> createAppointemt(AddorEditAppointmentDTO appointment) async {
    try {
      await repository.createAppointment(appointment);
      fetchAppointments();
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }

  Future<void> updateAppointemt(AddorEditAppointmentDTO appointment) async {
    try {
      await repository.updateAppointment(appointment);
      fetchAppointments();
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }

  Future<List<AllDoctorsInfoDTO>> searchDoctors(String query) async {
    try {
      final doctors = await repository.fetchDoctors();
      return doctors
          .where((doctor) =>
              doctor.personName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search doctors: $e');
    }
  }
}
