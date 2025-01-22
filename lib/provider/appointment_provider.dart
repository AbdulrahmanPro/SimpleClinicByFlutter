import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/appointment_repository.dart';
import 'package:test_provider_mvvm/model/apointment_dto.dart';
import 'package:test_provider_mvvm/model_view/appointment/appointment_view_model.dart';

final appointmentRepositoryProvider =
    Provider((ref) => AppointmentRepository());

final appointmentViewModelProvider = StateNotifierProvider<AppointmentViewModel,
    AsyncValue<List<AppointmentDTO>>>(
  (ref) => AppointmentViewModel(ref.read(appointmentRepositoryProvider)),
);
