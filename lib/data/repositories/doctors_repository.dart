import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_provider_mvvm/model/doctors_dto.dart';
import 'package:test_provider_mvvm/model/all_doctors_info_dto.dart';
import 'baseurl/baseural.dart';

class DoctorRepository {
  // Fetch all doctors
   Future<List<AllDoctorsInfoDTO>> fetchAllDoctors() async {
    final response =
        await http.get(Uri.parse('${Baseural.baseUrl}/Doctors/All'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((doctor) => AllDoctorsInfoDTO.fromJson(doctor)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  // Fetch a single doctor by ID
  Future<AllDoctorsInfoDTO?> fetchDoctorById(int id) async {
    final response =
        await http.get(Uri.parse('${Baseural.baseUrl}/Doctors/Find/$id'));

    if (response.statusCode == 200) {
      return AllDoctorsInfoDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load doctor');
    }
  }

  // Add a new doctor
  Future<void> addDoctor(DoctorsDTO doctor) async {
    final response = await http.post(
      Uri.parse('${Baseural.baseUrl}/Doctors/Add'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(doctor.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add doctor');
    }
  }

  // Update a doctor
  Future<void> updateDoctor(int id, DoctorsDTO updatedDoctor) async {
    final response = await http.put(
      Uri.parse('${Baseural.baseUrl}/Doctors/Update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(updatedDoctor.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update doctor');
    }
  }

  // Delete a doctor
  Future<void> deleteDoctor(int id) async {
    final response =
        await http.delete(Uri.parse('${Baseural.baseUrl}/Doctors/Delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete doctor');
    }
  }
}
