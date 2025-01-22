import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_provider_mvvm/model/prescriptions_dto.dart';
import 'package:test_provider_mvvm/data/repositories/baseurl/baseural.dart';

class PrescriptionsRepository {
  Future<List<PrescriptionsDTO>> fetchPrescriptions() async {
    try {
      final response =
          await http.get(Uri.parse('${Baseural.baseUrl}/prescriptions'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PrescriptionsDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load prescriptions');
      }
    } catch (e) {
      throw Exception('Error fetching prescriptions: $e');
    }
  }

  Future<void> createPrescription(PrescriptionsDTO prescription) async {
    try {
      final response = await http.post(
        Uri.parse('${Baseural.baseUrl}/prescriptions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(prescription.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create prescription');
      }
    } catch (e) {
      throw Exception('Error creating prescription: $e');
    }
  }

  Future<void> updatePrescription(int id, PrescriptionsDTO prescription) async {
    try {
      final response = await http.put(
        Uri.parse('${Baseural.baseUrl}/prescriptions/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(prescription.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update prescription');
      }
    } catch (e) {
      throw Exception('Error updating prescription: $e');
    }
  }

  Future<void> deletePrescription(int id) async {
    try {
      final response =
          await http.delete(Uri.parse('${Baseural.baseUrl}/prescriptions/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete prescription');
      }
    } catch (e) {
      throw Exception('Error deleting prescription: $e');
    }
  }
}
