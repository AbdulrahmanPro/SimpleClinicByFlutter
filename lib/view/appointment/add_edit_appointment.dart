import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/model/all_doctors_info_dto.dart';
import 'package:test_provider_mvvm/model/apointment.dart';
import 'package:test_provider_mvvm/model/apointment_dto.dart';
import 'package:test_provider_mvvm/model/patient_all_info_dto.dart';
import 'package:test_provider_mvvm/provider/add_edit_appointment_provider.dart';
import 'package:test_provider_mvvm/provider/appointment_provider.dart';
import 'package:test_provider_mvvm/provider/doctor_provider.dart';
import 'package:test_provider_mvvm/provider/patients_provider.dart';

class AppointmentDialog extends ConsumerStatefulWidget {
  final AppointmentDTO? appointment;

  const AppointmentDialog(this.appointment, {super.key});

  @override
  ConsumerState<AppointmentDialog> createState() => _AppointmentDialogState();
}

enum AppointmentStatus { neww, cancelled, waiting, completed }

class _AppointmentDialogState extends ConsumerState<AppointmentDialog> {
  late TextEditingController _personNameController;
  late TextEditingController _doctorNameController;
  late TextEditingController _specializationController;
  late TextEditingController _appointmentDateController;

  DateTime? _selectedDate;
  AppointmentStatus _selectedStatus = AppointmentStatus.neww;
  int _patientId = 0;
  int _doctorId = 0;

  @override
  void initState() {
    super.initState();
    _personNameController =
        TextEditingController(text: widget.appointment?.personName ?? '');
    _doctorNameController =
        TextEditingController(text: widget.appointment?.doctorName ?? '');
    _specializationController =
        TextEditingController(text: widget.appointment?.specialization ?? '');
    _appointmentDateController =
        TextEditingController(text: widget.appointment?.appointmentDate ?? '');

    _selectedDate = widget.appointment?.appointmentDate != null
        ? DateTime.tryParse(widget.appointment!.appointmentDate)
        : DateTime.now();

    _selectedStatus =
        _stringToStatus(widget.appointment?.appointmentStatus ?? 'New');
    _patientId = widget.appointment?.patientId ?? 0;
    _doctorId = widget.appointment?.doctorId ?? 0;
  }

  @override
  void dispose() {
    _personNameController.dispose();
    _doctorNameController.dispose();
    _specializationController.dispose();
    _appointmentDateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  AppointmentStatus _stringToStatus(String status) {
    switch (status) {
      case 'New':
        return AppointmentStatus.neww;
      case 'Cancelled':
        return AppointmentStatus.cancelled;
      case 'Waiting':
        return AppointmentStatus.waiting;
      case 'Completed':
        return AppointmentStatus.completed;
      default:
        return AppointmentStatus.neww;
    }
  }

  String _statusToString(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.neww:
        return 'New';
      case AppointmentStatus.cancelled:
        return 'Cancelled';
      case AppointmentStatus.waiting:
        return 'Waiting';
      case AppointmentStatus.completed:
        return 'Completed';
    }
  }

  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedDate == null
              ? 'Select Date'
              : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
        ),
        TextButton.icon(
          icon: const Icon(Icons.date_range),
          onPressed: () => _pickDate(context),
          label: const Text('Pick Date'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final patients = ref.watch(patientViewModelProvider);
    final doctors = ref.watch(doctorViewModelProvider);
    final viewModel = ref.watch(addEditAppointmentViewModelProvider);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              patients.when(
                data: (patientList) => Autocomplete<PatientAllInfoDTO>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<PatientAllInfoDTO>.empty();
                    }
                    return patientList.where((patient) => patient.personName!
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  },
                  displayStringForOption: (PatientAllInfoDTO patient) =>
                      patient.personName!,
                  onSelected: (PatientAllInfoDTO selectedPatient) {
                    setState(() {
                      _personNameController.text = selectedPatient.personName!;
                      _patientId = selectedPatient.id;
                    });
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                    controller.text =
                        _personNameController.text; // تعيين القيم السابقة
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration:
                          const InputDecoration(labelText: 'Patient Name'),
                    );
                  },
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              const SizedBox(
                height: 10,
              ),
              doctors.when(
                data: (doctorsList) => Autocomplete<AllDoctorsInfoDTO>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<AllDoctorsInfoDTO>.empty();
                    }
                    return doctorsList.where((doctor) => doctor.personName
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  },
                  displayStringForOption: (AllDoctorsInfoDTO doctor) =>
                      doctor.personName,
                  onSelected: (AllDoctorsInfoDTO selectedDoctor) {
                    setState(() {
                      _doctorNameController.text = selectedDoctor.personName;
                      _doctorId = selectedDoctor.id;
                      _specializationController.text =
                          selectedDoctor.specialization;
                    });
                  },
                  fieldViewBuilder:
                      (context, controller, focusNode, onEditingComplete) {
                    controller.text =
                        _doctorNameController.text; // تعيين القيم السابقة
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration:
                          const InputDecoration(labelText: 'Doctor Name'),
                    );
                  },
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => Text('Error: $error'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _specializationController,
                decoration: const InputDecoration(labelText: 'Specialization'),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButton<AppointmentStatus>(
                hint: const Text('Select Status'),
                value: _selectedStatus,
                items: AppointmentStatus.values.map((AppointmentStatus status) {
                  return DropdownMenuItem<AppointmentStatus>(
                    value: status,
                    child: Text(_statusToString(status)),
                  );
                }).toList(),
                onChanged: (AppointmentStatus? newValue) {
                  setState(() {
                    if (newValue != null) _selectedStatus = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildDatePicker(),
              const SizedBox(height: 20),
              if (viewModel.isLoading) const CircularProgressIndicator(),
              if (!viewModel.isLoading)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final appointment = AddorEditAppointmentDTO(
                          id: widget.appointment?.id ?? 0,
                          patientId: _patientId,
                          personName: _personNameController.text,
                          doctorId: _doctorId,
                          doctorName: _doctorNameController.text,
                          specialization: _specializationController.text,
                          appointmentDate: _selectedDate!,
                          appointmentStatus: _selectedStatus.index + 1,
                          medicalRecordId: null,
                          paymentId: null,
                        );
                        if (appointment.id == 0) {
                          await ref
                              .read(appointmentViewModelProvider.notifier)
                              .createAppointemt(appointment);
                        } else {
                          await ref
                              .read(appointmentViewModelProvider.notifier)
                              .updateAppointemt(appointment);
                        }
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
