import 'package:test_provider_mvvm/model/usermodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/userrepositry.dart';

class UserViewModel extends StateNotifier<AsyncValue<List<UserModel>>> {
  final UserRepositry repository;

  UserViewModel(this.repository) : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      state = const AsyncValue.loading();
      final users = await repository.fetchUsers();
      state = AsyncValue.data(users);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await repository.createUser(user);
      await fetchUsers(); // Refresh the list
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateUser(int id, UserModel user) async {
    try {
      await repository.updateUser(id, user);
      await fetchUsers(); // Refresh the list
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await repository.deleteUser(id);
      await fetchUsers(); // Refresh the list
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  }