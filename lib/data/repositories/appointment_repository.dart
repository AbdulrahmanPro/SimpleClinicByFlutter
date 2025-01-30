import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_provider_mvvm/model/all_doctors_info_dto.dart';
import 'package:test_provider_mvvm/model/apointment.dart';
import 'package:test_provider_mvvm/model/apointment_dto.dart';
import 'package:test_provider_mvvm/data/repositories/baseurl/baseural.dart';
import 'package:test_provider_mvvm/model/patient_all_info_dto.dart';

class AppointmentRepository {
  Future<List<AppointmentDTO>> fetchAppointments() async {
    try {
      final response =
          await http.get(Uri.parse('${Baseural.baseUrl}/AppointmentApi/All'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => AppointmentDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      throw Exception('Error fetching appointments: $e');
    }
  }

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

  Future<List<AllDoctorsInfoDTO>> fetchDoctors() async {
    final response =
        await http.get(Uri.parse('${Baseural.baseUrl}/Doctors/All'));
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((json) => AllDoctorsInfoDTO.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to fetch doctors');
    }
  }

  Future<AddorEditAppointmentDTO> createAppointment(
      AddorEditAppointmentDTO appointment) async {
    try {
      final response = await http.post(
        Uri.parse('${Baseural.baseUrl}/AppointmentApi/Add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointment.toJson()),
      );
      if (response.statusCode == 201) {
        return AddorEditAppointmentDTO.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create appointment');
      }
    } catch (e) {
      throw Exception('Error creating appointment: $e');
    }
  }

  Future<void> updateAppointment(AddorEditAppointmentDTO appointment) async {
    try {
      final response = await http.put(
        Uri.parse(
            '${Baseural.baseUrl}/AppointmentApi/Update/${appointment.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(appointment.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update appointment');
      }
    } catch (e) {
      throw Exception('Error updating appointment: $e');
    }
  }

  Future<void> deleteAppointment(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('${Baseural.baseUrl}/AppointmentApi/Delete/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete appointment');
      }
    } catch (e) {
      throw Exception('Error deleting appointment: $e');
    }
  }
}
