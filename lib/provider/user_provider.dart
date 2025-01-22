import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/userrepositry.dart';
import 'package:test_provider_mvvm/model/usermodel.dart';
import 'package:test_provider_mvvm/model_view/users/user_view_model.dart';

final userRepositoryProvider = Provider((ref) => UserRepositry());

final userViewModelProvider =
    StateNotifierProvider<UserViewModel, AsyncValue<List<UserModel>>>(
  (ref) => UserViewModel(ref.read(userRepositoryProvider))
);



