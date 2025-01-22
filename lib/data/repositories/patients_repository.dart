import 'package:http/http.dart' as http;
import 'package:test_provider_mvvm/model/patient_all_info_dto.dart';
import 'package:test_provider_mvvm/model/patients_dto.dart';
import 'package:test_provider_mvvm/data/repositories/baseurl/baseural.dart';
import 'dart:convert';

class PatientRepository {
  // Link a person to a patient
  Future<PatientsDTO> addPatient(PatientsDTO patient) async {
    final response = await http.post(
      Uri.parse('${Baseural.baseUrl}/Patient/Add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 201) {
      return PatientsDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add patient');
    }
  }

  // Get all patients with their details
  Future<List<PatientAllInfoDTO>> fetchAllPatients() async {
    final response =
        await http.get(Uri.parse('${Baseural.baseUrl}/Patient/All'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => PatientAllInfoDTO.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch patients');
    }
  }

  // Delete a patient by ID
  Future<void> deletePatient(int patientId) async {
    final response = await http.delete(
      Uri.parse('${Baseural.baseUrl}/Patient/Delete/$patientId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete patient');
    }
  }

  // Update a patient
  Future<PatientsDTO> updatePatient(int patientId, PatientsDTO patient) async {
    final response = await http.put(
      Uri.parse('${Baseural.baseUrl}/Patient/Update/$patientId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 200) {
      return PatientsDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update patient');
    }
  }

  // Fetch a single patient by ID
  Future<PatientAllInfoDTO> fetchPatientById(int patientId) async {
    final response = await http.get(
      Uri.parse('${Baseural.baseUrl}/Patient/Find/$patientId'),
    );

    if (response.statusCode == 200) {
      return PatientAllInfoDTO.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch patient details');
    }
  }
}
