import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/appointment_repository.dart';
import 'package:test_provider_mvvm/model/apointment_dto.dart';

class AddEditAppointmentViewModel
    extends StateNotifier<AsyncValue<AppointmentDTO?>> {
  final AppointmentRepository repository;

  AddEditAppointmentViewModel(this.repository)
      : super(const AsyncValue.data(null));

  Future<void> saveAppointment(AppointmentDTO appointment) async {
    state = const AsyncValue.loading(); // تعيين حالة "جاري الحفظ"

    try {
      if (appointment.id == 0) {
        // إذا كان `id` يساوي 0، اعتبره عملية إضافة
        await repository.createAppointment(appointment);
      } else {
        // إذا كان `id` موجودًا، اعتبره عملية تعديل
        await repository.updateAppointment(appointment);
      }
      state = AsyncValue.data(appointment); // تعيين الحالة كنجاح
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current); // التعامل مع الأخطاء
    }
  }
}
