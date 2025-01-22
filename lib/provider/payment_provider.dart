import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/payment_repository.dart';
import 'package:test_provider_mvvm/model/payment_dto.dart';
import 'package:test_provider_mvvm/model_view/payment/payment_view_model.dart';

final paymentRepositoryProvider = Provider((ref) => PaymentRepository());

final paymentViewModelProvider =
    StateNotifierProvider<PaymentViewModel, AsyncValue<List<PaymentDTO>>>(
  (ref) => PaymentViewModel(ref.read(paymentRepositoryProvider)),
);
