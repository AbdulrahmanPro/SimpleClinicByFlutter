import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_provider_mvvm/model/person_model.dart';
import 'package:test_provider_mvvm/data/repositories/baseurl/baseural.dart';

class PersonRepository {
  // جلب جميع الأشخاص
  Future<List<PersonModel>> fetchPersons() async {
    try {
      final response =
          await http.get(Uri.parse('${Baseural.baseUrl}/Persons/All'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PersonModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch persons: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching persons: $e');
    }
  }

  // جلب شخص عن طريق ID
  Future<PersonModel> fetchPersonById(int id) async {
    try {
      final response =
          await http.get(Uri.parse('${Baseural.baseUrl}/Persons/Find/$id'));
      if (response.statusCode == 200) {
        return PersonModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch person: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching person by ID: $e');
    }
  }

  // إضافة شخص جديد
  Future<int> createPerson(PersonModel person) async {
    try {
      final response = await http.post(
        Uri.parse('${Baseural.baseUrl}/Persons/Add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(person.toJson()),
      );
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return data['id'];
      } else {
        return -1;
      }
    } catch (e) {
      throw Exception('Error creating person: $e');
    }
  }

  // تحديث شخص
  Future<void> updatePerson(int id, PersonModel person) async {
    try {
      final response = await http.put(
        Uri.parse('${Baseural.baseUrl}/Persons/Update/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(person.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update person: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating person: $e');
    }
  }

  // حذف شخص
  Future<void> deletePerson(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('${Baseural.baseUrl}/Persons/Delete/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete person: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting person: $e');
    }
  }
}
