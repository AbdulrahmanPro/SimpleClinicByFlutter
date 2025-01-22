import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/model/doctors_dto.dart';
import 'package:test_provider_mvvm/model/person_model.dart';
import 'package:test_provider_mvvm/provider/doctor_provider.dart';
import 'package:test_provider_mvvm/view/doctor/add_edit_doctor.dart';
import 'package:test_provider_mvvm/view/widgets/persin_list_tile.dart';

class DoctorScreen extends ConsumerWidget {
  const DoctorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doctorState = ref.watch(doctorViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors'),
      ),
      body: doctorState.when(
        data: (doctors) {
          if (doctors.isEmpty) {
            return const Center(child: Text('No doctors found.'));
          }
          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              final person = PersonModel(
                id: doctor.personId,
                personName: doctor.personName,
                dateOfBirth: doctor.dateOfBirth,
                gender: doctor.gender,
                phoneNumber: doctor.phoneNumber,
                email: doctor.email,
                address: doctor.address,
              );

              return PersonTile(
                key: ValueKey(doctor.id),
                person: person,
                onDelete: () {
                  ref
                      .read(doctorViewModelProvider.notifier)
                      .deleteDoctor(doctor.id);
                },
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddOrEditPersonAndDoctorDialog(
                      personModel: person,
                      doctorsDTO: DoctorsDTO(
                        id: doctor.id,
                        personId: doctor.personId,
                        specialization: doctor.specialization,
                      ),
                      onSubmit: (PersonModel updatedPerson,
                          DoctorsDTO? updatedDoctor) {
                        if (updatedDoctor != null) {
                          ref
                              .read(doctorViewModelProvider.notifier)
                              .updateDoctor(updatedPerson, updatedDoctor);
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: () {
            // عرض نافذة الحوار لإضافة طبيب جديد
            showDialog(
              context: context,
              builder: (context) => AddOrEditPersonAndDoctorDialog(
                onSubmit: (PersonModel person, DoctorsDTO? doctor) {
                  if (doctor != null) {
                    ref
                        .read(doctorViewModelProvider.notifier)
                        .addDoctorWithPerson(person, doctor);
                  }
                },
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
