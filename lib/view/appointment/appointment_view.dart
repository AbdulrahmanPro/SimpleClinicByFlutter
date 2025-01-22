import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/model/apointment_dto.dart';
import 'package:test_provider_mvvm/provider/appointment_provider.dart';
import 'package:test_provider_mvvm/view/appointment/add_edit_appointment.dart';

class AppointmentView extends ConsumerWidget {
  const AppointmentView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentDTO = ref.watch(appointmentViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: appointmentDTO.when(
        data: (appointments) => ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return AppointmentTile(
                key: Key(appointment.id.toString()),
                appointments: appointment,
                onDelete: () {
                  ref
                      .read(appointmentViewModelProvider.notifier)
                      .deleteAppointment(appointment.id);
                },
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AppointmentDialog(appointment));
                },
              );
            }),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const AppointmentDialog(null)))),
    );
  }
}

class AppointmentTile extends StatelessWidget {
  final AppointmentDTO appointments;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const AppointmentTile({
    required Key key,
    required this.appointments,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 6, 131, 159),
                Color.fromARGB(255, 8, 153, 179)
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: ListTile(
            leading: const Icon(Icons.supervised_user_circle_sharp),
            title: Text(
              appointments.personName!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              appointments.appointmentDate,
              style: const TextStyle(
                color: Color.fromARGB(255, 233, 233, 233),
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
              onPressed: (onDelete),
            ),
            onTap: onTap,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.blueAccent,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ],
    );
  }
}
