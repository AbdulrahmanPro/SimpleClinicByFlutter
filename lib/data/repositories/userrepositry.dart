import 'dart:convert';
import 'package:test_provider_mvvm/model/usermodel.dart';
import 'baseurl/baseural.dart';
import 'package:http/http.dart' as http;

class UserRepositry {
  Future<List<UserModel>> fetchUsers() async {
    try {
      final response =
          await http.get(Uri.parse('${Baseural.baseUrl}/UserApi/All'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch persons: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error in fetchUsers: $e');
    }
  }

  Future<UserModel> getUserByID(int id) async {
    try {
      final response =
          await http.get(Uri.parse('${Baseural.baseUrl}/UserApi/Find/$id)'));
      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to get user by ID: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error in getUserByID: $e');
    }
  }

  Future<void> createUser(UserModel newUser) async {
    try {
      final response = await http.post(
        Uri.parse('${Baseural.baseUrl}/UserApi/Add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(newUser.toJson()),
      );
    } catch (e) {
      throw Exception('Error in createUser: $e');
    }
  }

  Future<bool> fetchPersonByUserNameAndPassword(
      String userName, String password) async {
    try {
      final response = await http.get(Uri.parse(
          '${Baseural.baseUrl}/UserApi/CheckCredentials/UserName/$userName/Password/$password'));

      if (response.statusCode == 200) {
        bool isValid = true;
        return isValid;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> updateUser(int id, UserModel user) async {
    try {
      final response = await http.put(
        Uri.parse('${Baseural.baseUrl}/UserApi/Update/Id/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error in updateUser: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('${Baseural.baseUrl}/UserApi/Delete/Id/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error in deleteUser: $e');
    }
  }
}
