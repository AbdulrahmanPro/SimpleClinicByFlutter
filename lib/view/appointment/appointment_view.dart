import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/model/apointment_dto.dart';
import 'package:test_provider_mvvm/provider/appointment_provider.dart';
import 'package:test_provider_mvvm/view/appointment/add_edit_appointment.dart';

class AppointmentView extends ConsumerStatefulWidget {
  const AppointmentView({super.key});

  @override
  ConsumerState<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends ConsumerState<AppointmentView> {
  String searchQuery = '';
  String filterStatus = 'All';
  String sortBy = 'Date';

  @override
  Widget build(BuildContext context) {
    final appointmentDTO = ref.watch(appointmentViewModelProvider);
    double screenWidth = MediaQuery.of(context).size.width;
    double padding = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search for Appointment ... ",
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
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: sortBy,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Date', child: Text('sort by Date')),
                        DropdownMenuItem(
                            value: 'Patient', child: Text('sort by Patient')),
                        DropdownMenuItem(
                            value: 'Doctor', child: Text('sort by Doctor')),
                      ],
                      onChanged: (value) => setState(() => sortBy = value!),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: filterStatus,
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(value: 'New', child: Text('New')),
                        DropdownMenuItem(
                            value: 'Completed', child: Text('Completed')),
                        DropdownMenuItem(
                            value: 'Cancelled', child: Text('Cancelled')),
                        DropdownMenuItem(
                            value: 'Waiting', child: Text('Waiting')),
                      ],
                      onChanged: (value) =>
                          setState(() => filterStatus = value!),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: appointmentDTO.when(
        data: (appointments) {
          var filteredAppointments = filterAppointments(appointments);

          if (filteredAppointments.isEmpty) {
            return const Center(child: Text('There are no Appointment'));
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: padding),
            itemCount: filteredAppointments.length,
            itemBuilder: (context, index) {
              final appointment = filteredAppointments[index];

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
                    builder: (context) => AppointmentDialog(appointment),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('حدث خطأ: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => const AppointmentDialog(null),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<AppointmentDTO> filterAppointments(List<AppointmentDTO> appointments) {
    var filteredAppointments = filterStatus == 'All'
        ? appointments
        : appointments
            .where(
                (appointment) => appointment.appointmentStatus == filterStatus)
            .toList();

    filteredAppointments = filteredAppointments
        .where((appointment) =>
            appointment.personName!.toLowerCase().contains(searchQuery) ||
            appointment.doctorName!.toLowerCase().contains(searchQuery))
        .toList();

    filteredAppointments.sort((a, b) {
      if (sortBy == 'Date') {
        return DateTime.parse(b.appointmentDate)
            .compareTo(DateTime.parse(a.appointmentDate));
      } else if (sortBy == 'Patient') {
        return a.personName!.compareTo(b.personName!);
      } else if (sortBy == 'Doctor') {
        return a.doctorName!.compareTo(b.doctorName!);
      }
      return 0;
    });

    return filteredAppointments;
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
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          appointments.personName!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${appointments.appointmentDate} - ${appointments.doctorName}',
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
