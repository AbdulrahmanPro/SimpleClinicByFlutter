// مزود ViewModel
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/appointment_repository.dart';
import 'package:test_provider_mvvm/model/apointment_dto.dart';
import 'package:test_provider_mvvm/model_view/appointment/add_edit_view_model.dart';

final addEditAppointmentViewModelProvider = StateNotifierProvider.autoDispose<
    AddEditAppointmentViewModel, AsyncValue<AppointmentDTO?>>((ref) {
  return AddEditAppointmentViewModel(AppointmentRepository());
});
