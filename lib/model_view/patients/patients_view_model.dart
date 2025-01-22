import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/patients_repository.dart';
import 'package:test_provider_mvvm/data/repositories/person_repository.dart';
import 'package:test_provider_mvvm/model/patient_all_info_dto.dart';
import 'package:test_provider_mvvm/model/patients_dto.dart';
import 'package:test_provider_mvvm/model/person_model.dart';

class PatientViewModel
    extends StateNotifier<AsyncValue<List<PatientAllInfoDTO>>> {
  final PatientRepository _patientRepository;
  final PersonRepository _personRepository;

  PatientViewModel(this._patientRepository, this._personRepository)
      : super(const AsyncValue.loading()){
            fetchPatients();

      }

  /// Fetch all patients
  Future<void> fetchPatients() async {
    try {
      state = const AsyncValue.loading();
      final patients = await _patientRepository.fetchAllPatients();
      state = AsyncValue.data(patients);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  /// Add a new patient (linking person to patient)
  Future<void> addNewPatient(PersonModel person) async {
    try {
      // Add person
      final newPerson = await _personRepository.createPerson(person);
      PatientsDTO patient = PatientsDTO(id: 0, personId: newPerson);

      // Link person to patient
      patient.personId = newPerson;
      await _patientRepository.addPatient(patient);

      // Refresh patient list
      await fetchPatients();
    } catch (error) {
      state = AsyncValue.error(
          'Failed to add new patient: $error', StackTrace.current);
    }
  }

  /// Update an existing patient
  Future<void> updatePatient(int patientId, PersonModel updatedPerson) async {
    try {
      // Update the person
      await _personRepository.updatePerson(updatedPerson.id, updatedPerson);

      // Update the patient

      // Refresh patient list
      await fetchPatients();
    } catch (error) {
      state = AsyncValue.error(
          'Failed to update patient: $error', StackTrace.current);
    }
  }

  /// Delete a patient
  Future<void> deletePatient(int patientId) async {
    try {
      // Delete patient
      await _patientRepository.deletePatient(patientId);

      // Optionally delete the person linked to the patient

      // Refresh patient list
      await fetchPatients();
    } catch (error) {
      state = AsyncValue.error(
          'Failed to delete patient: $error', StackTrace.current);
    }
  }

  /// Fetch a specific patient by ID
  Future<PatientAllInfoDTO?> fetchPatientById(int patientId) async {
    try {
      return await _patientRepository.fetchPatientById(patientId);
    } catch (error) {
      state = AsyncValue.error(
          'Failed to fetch patient details: $error', StackTrace.current);
      return null;
    }
  }
}
