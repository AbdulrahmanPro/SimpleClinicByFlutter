import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/prescriptions_repository.dart';
import 'package:test_provider_mvvm/model/prescriptions_dto.dart';
import 'package:test_provider_mvvm/model_view/prescriptions/prescriptions_view_model.dart';

final prescriptionsRepositoryProvider =
    Provider((ref) => PrescriptionsRepository());

final prescriptionsViewModelProvider = StateNotifierProvider<
    PrescriptionsViewModel, AsyncValue<List<PrescriptionsDTO>>>(
  (ref) => PrescriptionsViewModel(ref.read(prescriptionsRepositoryProvider)),
);
