import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/payment_repository.dart';
import 'package:test_provider_mvvm/model/payment_dto.dart';

class PaymentViewModel extends StateNotifier<AsyncValue<List<PaymentDTO>>> {
  final PaymentRepository repository;

  PaymentViewModel(this.repository) : super(const AsyncValue.loading()) {
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    try {
      state = const AsyncValue.loading();
      final payments = await repository.fetchPayments();
      state = AsyncValue.data(payments);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createPayment(PaymentDTO payment) async {
    try {
      state = const AsyncValue.loading();
      await repository.createPayment(payment);
      fetchPayments(); // Refresh the list after creating the payment
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updatePayment(int id, PaymentDTO payment) async {
    try {
      await repository.updatePayment(id, payment);
      fetchPayments(); // Refresh the list after updating the payment
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deletePayment(int id) async {
    try {
      await repository.deletePayment(id);
      fetchPayments(); // Refresh the list after deleting the payment
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}
