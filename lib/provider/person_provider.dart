import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/person_repository.dart';
import 'package:test_provider_mvvm/model/person_model.dart';
import 'package:test_provider_mvvm/model_view/person/person_view_model.dart';

final personRepositoryProvider = Provider((ref) => PersonRepository());

final personViewModelProvider =
    StateNotifierProvider<PersonViewModel, AsyncValue<List<PersonModel>>>(
  (ref) => PersonViewModel(ref.read(personRepositoryProvider)),
);
