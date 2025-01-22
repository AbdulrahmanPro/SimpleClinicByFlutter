import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/person_repository.dart';
import 'package:test_provider_mvvm/model/person_model.dart';

class PersonViewModel extends StateNotifier<AsyncValue<List<PersonModel>>> {
  final PersonRepository repository;

  PersonViewModel(this.repository) : super(const AsyncValue.loading()) {
    fetchPersons();
  }

  Future<void> fetchPersons() async {
    try {
      state = const AsyncValue.loading();
      final persons = await repository.fetchPersons();
      state = AsyncValue.data(persons);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<PersonModel> getPersonByID(int id) async {
    try {
      final person = await repository.fetchPersonById(id);
      return person;
    } catch (e, stackTrace) {
      // تعيين حالة الخطأ إلى State
      state = AsyncValue.error(e, stackTrace);
      // إعادة رمي الخطأ لضمان معرفته في أماكن الاستدعاء
      throw Exception('Failed to fetch person with ID $id: $e');
    }
  }

  Future<int> createPerson(PersonModel person) async {
    int id = -1;
    try {
      id = await repository.createPerson(person);
      await fetchPersons();
      return id; // Refresh the list
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
    return id;
  }

  Future<void> updatePerson(int id, PersonModel person) async {
    try {
      await repository.updatePerson(id, person);
      await fetchPersons(); // Refresh the list
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deletePerson(int id) async {
    try {
      await repository.deletePerson(id);
      await fetchPersons(); // Refresh the list
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

}
