import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/provider/person_provider.dart';
import 'package:test_provider_mvvm/view/widgets/add_person.dart';
import 'package:test_provider_mvvm/view/widgets/persin_list_tile.dart';

class PersonListScreen extends ConsumerWidget {
  const PersonListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personList = ref.watch(personViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'إدارة الأشخاص',
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color.fromARGB(255, 6, 131, 159),
      ),
      body: personList.when(
        data: (persons) => ListView.builder(
          itemCount: persons.length,
          itemBuilder: (context, index) {
            final person = persons[index];
            return PersonTile(
              key: ValueKey(person.id),
              person: person,
              onDelete: () {
                ref
                    .read(personViewModelProvider.notifier)
                    .deletePerson(person.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم حذف ${person.personName} بنجاح!')),
                );
              },
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AddPersonDialog(
                    personModel: person,
                    onSubmit: (updatedPerson) => ref
                        .read(personViewModelProvider.notifier)
                        .updatePerson(person.id, updatedPerson),
                  ),
                );
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('حدث خطأ: $err'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddPersonDialog(
                onSubmit:
                    ref.read(personViewModelProvider.notifier).createPerson,
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
