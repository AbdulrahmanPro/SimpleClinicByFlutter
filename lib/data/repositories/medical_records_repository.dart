import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_provider_mvvm/model/medical_records_dto.dart';
import 'package:test_provider_mvvm/data/repositories/baseurl/baseural.dart';

class MedicalRecordsRepository {
  Future<List<MedicalRecordsDTO>> fetchMedicalRecords() async {
    try {
      final response = await http.get(Uri.parse('${Baseural.baseUrl}/medicalrecords'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => MedicalRecordsDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load medical records');
      }
    } catch (e) {
      throw Exception('Error fetching medical records: $e');
    }
  }

  Future<void> createMedicalRecord(MedicalRecordsDTO record) async {
    try {
      final response = await http.post(
        Uri.parse('${Baseural.baseUrl}/medicalrecords'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(record.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create medical record');
      }
    } catch (e) {
      throw Exception('Error creating medical record: $e');
    }
  }

  Future<void> updateMedicalRecord(int id, MedicalRecordsDTO record) async {
    try {
      final response = await http.put(
        Uri.parse('${Baseural.baseUrl}/medicalrecords/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(record.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update medical record');
      }
    } catch (e) {
      throw Exception('Error updating medical record: $e');
    }
  }

  Future<void> deleteMedicalRecord(int id) async {
    try {
      final response = await http.delete(Uri.parse('${Baseural.baseUrl}/medicalrecords/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete medical record');
      }
    } catch (e) {
      throw Exception('Error deleting medical record: $e');
    }
  }
}
