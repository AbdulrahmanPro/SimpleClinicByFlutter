import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/model/person_model.dart';
import 'package:test_provider_mvvm/provider/patients_provider.dart';
import 'package:test_provider_mvvm/view/widgets/add_person.dart';
import 'package:test_provider_mvvm/view/widgets/persin_list_tile.dart';
import 'package:test_provider_mvvm/view/widgets/show_delete_dialog.dart';

class PatientScreen extends ConsumerWidget {
  const PatientScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patientState = ref.watch(patientViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients'),
      ),
      body: patientState.when(
        data: (patients) {
          if (patients.isEmpty) {
            return const Center(child: Text('No patients found.'));
          }
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              final person = PersonModel(
                id: patient.personId,
                personName: patient.personName ?? '',
                dateOfBirth: DateTime.parse(patient.dateOfBirth),
                gender: patient.gender ?? '',
                phoneNumber: patient.phoneNumber ?? '',
                email: patient.email ?? '',
                address: patient.address ?? '',
              );

              return PersonTile(
                key: ValueKey(patient.id),
                person: person,
                onDelete: () async {
                  bool? confirmDelete =
                      await DialogMassage.showConfirmDeleteDialog(context);
                  if (confirmDelete == true) {
                    ref
                        .read(patientViewModelProvider.notifier)
                        .deletePatient(patient.id);
                  }
                },
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AddPersonDialog(
                      personModel: person,
                      onSubmit: (PersonModel person) {
                         ref
                            .read(patientViewModelProvider.notifier)
                            .updatePatient(person.id, person);

                       
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
            // عرض نافذة الحوار لإضافة مريض جديد
            showDialog(
              context: context,
              builder: (context) => AddPersonDialog(
                onSubmit: (PersonModel person) {
                  // استدعاء الوظيفة لإضافة المريض الجديد
                  ref
                      .read(patientViewModelProvider.notifier)
                      .addNewPatient(person);
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
