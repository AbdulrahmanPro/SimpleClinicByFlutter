import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/userrepositry.dart';
import 'package:test_provider_mvvm/model_view/users/user_login_view_model.dart';

final userLoginRepositoryProvider = Provider((ref) => UserRepositry());

final userLoginViewModelProvider =
    StateNotifierProvider<UserLoginViewModel, AsyncValue<bool>>(
  (ref) => UserLoginViewModel(ref.read(userLoginRepositoryProvider)),
);
