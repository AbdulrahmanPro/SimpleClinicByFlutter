import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_provider_mvvm/model/payment_dto.dart';
import 'package:test_provider_mvvm/data/repositories/baseurl/baseural.dart';

class PaymentRepository {
  Future<List<PaymentDTO>> fetchPayments() async {
    try {
      final response =
          await http.get(Uri.parse('${Baseural.baseUrl}/payments'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => PaymentDTO.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load payments');
      }
    } catch (e) {
      throw Exception('Error fetching payments: $e');
    }
  }

  Future<void> createPayment(PaymentDTO payment) async {
    try {
      final response = await http.post(
        Uri.parse('${Baseural.baseUrl}/payments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payment.toJson()),
      );
      if (response.statusCode != 201) {
        throw Exception('Failed to create payment');
      }
    } catch (e) {
      throw Exception('Error creating payment: $e');
    }
  }

  Future<void> updatePayment(int id, PaymentDTO payment) async {
    try {
      final response = await http.put(
        Uri.parse('${Baseural.baseUrl}/payments/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(payment.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update payment');
      }
    } catch (e) {
      throw Exception('Error updating payment: $e');
    }
  }

  Future<void> deletePayment(int id) async {
    try {
      final response =
          await http.delete(Uri.parse('${Baseural.baseUrl}/payments/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete payment');
      }
    } catch (e) {
      throw Exception('Error deleting payment: $e');
    }
  }
}
