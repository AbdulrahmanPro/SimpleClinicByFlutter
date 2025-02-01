import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/userrepositry.dart';

class UserLoginViewModel extends StateNotifier<AsyncValue<bool>> {
  final UserRepositry repository;

  UserLoginViewModel(this.repository) : super(const AsyncValue.loading());

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    try {
      final result =
          await repository.fetchPersonByUserNameAndPassword(username, password);
      state = AsyncValue.data(result);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.data(false);
  }
}
