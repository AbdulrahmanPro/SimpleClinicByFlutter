import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/model/doctors_dto.dart';
import 'package:test_provider_mvvm/model/person_model.dart';
import 'package:test_provider_mvvm/provider/doctor_provider.dart';
import 'package:test_provider_mvvm/view/doctor/add_edit_doctor.dart';
import 'package:test_provider_mvvm/view/widgets/persin_list_tile.dart';
import 'package:test_provider_mvvm/view/widgets/show_delete_dialog.dart';

class DoctorScreen extends ConsumerStatefulWidget {
  const DoctorScreen({super.key});

  @override
  ConsumerState<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends ConsumerState<DoctorScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final doctorState = ref.watch(doctorViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              width: constraints.maxWidth * 0.9,
              child: TextField(
                onChanged: (value) {
                  setState(() => searchQuery = value.trim().toLowerCase());
                },
                decoration: InputDecoration(
                  hintText: 'Search by doctor name',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            );
          },
        ),
      ),
      body: doctorState.when(
        data: (doctors) {
          final filteredDoctors = doctors.where((doctor) {
            return doctor.personName.toLowerCase().contains(searchQuery);
          }).toList();

          if (filteredDoctors.isEmpty) {
            return const Center(child: Text('No doctors found.'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              return ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth * 0.02,
                  vertical: 10,
                ),
                itemCount: filteredDoctors.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final doctor = filteredDoctors[index];
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
                    onDelete: () async {
                      bool? confirm =
                          await DialogMassage.showConfirmDeleteDialog(context);
                      if (confirm == true) {
                        ref
                            .read(doctorViewModelProvider.notifier)
                            .deleteDoctor(doctor.id);
                      }
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
                          onSubmit: (updatedPerson, updatedDoctor) {
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: SafeArea(
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddOrEditPersonAndDoctorDialog(
                onSubmit: (person, doctor) {
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
