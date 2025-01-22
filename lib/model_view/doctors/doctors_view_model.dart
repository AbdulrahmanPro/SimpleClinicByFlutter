import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/data/repositories/doctors_repository.dart';
import 'package:test_provider_mvvm/data/repositories/person_repository.dart';
import 'package:test_provider_mvvm/model/doctors_dto.dart';
import 'package:test_provider_mvvm/model/all_doctors_info_dto.dart';
import 'package:test_provider_mvvm/model/person_model.dart';

class DoctorViewModel
    extends StateNotifier<AsyncValue<List<AllDoctorsInfoDTO>>> {
  final PersonRepository _personRepository;
  final DoctorRepository _doctorRepository;

  DoctorViewModel(this._personRepository, this._doctorRepository)
      : super(const AsyncValue.loading()) {
    fetchDoctors();
  }

  // إضافة شخص وطبيب في نفس الوقت
  Future<void> addDoctorWithPerson(
      PersonModel person, DoctorsDTO doctor) async {
    try {
      state = const AsyncValue.loading();

      // أضف الشخص أولاً للحصول على personId
      final personId = await _personRepository.createPerson(person);

      // بعد الحصول على personId، أضف الطبيب باستخدام هذا الـ id
      final doctorWithPersonId = doctor.copyWith(personId: personId);
      await _doctorRepository.addDoctor(doctorWithPersonId);

      await fetchDoctors(); // تحديث البيانات بعد الإضافة
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  // تحديث الطبيب باستخدام personId
  Future<void> updateDoctor(
    PersonModel updatedPerson, DoctorsDTO updatedDoctor) async {
    try {
      state = const AsyncValue.loading();

      // تحديث الشخص أولاً
      await _personRepository.updatePerson(updatedPerson.id, updatedPerson);

      // ثم تحديث الطبيب
      await _doctorRepository.updateDoctor(updatedDoctor.id, updatedDoctor);

      await fetchDoctors(); // تحديث البيانات بعد التحديث
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  // استرجاع الأطباء
  Future<void> fetchDoctors() async {
    try {
      final doctors = await _doctorRepository.fetchAllDoctors();
      state = AsyncValue.data(doctors);
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
   Future<void> deleteDoctor(int doctorId) async {
    try {
      await _doctorRepository.deleteDoctor(doctorId);
      await fetchDoctors();
    } catch (error) {
      state = AsyncValue.error('Failed to delete doctor: $error',StackTrace.current);
    }
  }
  
}
