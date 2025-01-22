import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/model/apointment_dto.dart';
import 'package:test_provider_mvvm/provider/add_edit_appointment_provider.dart';

class AppointmentDialog extends ConsumerStatefulWidget {
  final AppointmentDTO? appointment; // إذا كانت فارغة، اعتبرها إضافة

  const AppointmentDialog(this.appointment, {super.key});

  @override
  ConsumerState<AppointmentDialog> createState() => _AppointmentDialogState();
}

class _AppointmentDialogState extends ConsumerState<AppointmentDialog> {
  late TextEditingController _personNameController;
  late TextEditingController _doctorNameController;
  late TextEditingController _specializationController;
  late TextEditingController _appointmentDateController;

  @override
  void initState() {
    super.initState();

    // تهيئة الحقول بالبيانات إذا كانت موجودة
    _personNameController =
        TextEditingController(text: widget.appointment?.personName ?? '');
    _doctorNameController =
        TextEditingController(text: widget.appointment?.doctorName ?? '');
    _specializationController =
        TextEditingController(text: widget.appointment?.specialization ?? '');
    _appointmentDateController =
        TextEditingController(text: widget.appointment?.appointmentDate ?? '');
  }

  @override
  void dispose() {
    _personNameController.dispose();
    _doctorNameController.dispose();
    _specializationController.dispose();
    _appointmentDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(addEditAppointmentViewModelProvider);
    final viewModelNotifier =
        ref.read(addEditAppointmentViewModelProvider.notifier);

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _personNameController,
              decoration: const InputDecoration(labelText: 'اسم المريض'),
            ),
            TextField(
              controller: _doctorNameController,
              decoration: const InputDecoration(labelText: 'اسم الدكتور'),
            ),
            TextField(
              controller: _specializationController,
              decoration: const InputDecoration(labelText: 'التخصص'),
            ),
            TextField(
              controller: _appointmentDateController,
              decoration: const InputDecoration(labelText: 'تاريخ الموعد'),
            ),
            const SizedBox(height: 20),
            if (viewModel.isLoading) const CircularProgressIndicator(),
            if (!viewModel.isLoading)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final appointment = AppointmentDTO(
                        id: widget.appointment?.id ?? 0,
                        patientId: widget.appointment?.patientId ??
                            1, // ثابت كقيمة افتراضية
                        personName: _personNameController.text,
                        doctorId: widget.appointment?.doctorId,
                        doctorName: _doctorNameController.text,
                        specialization: _specializationController.text,
                        appointmentDate: _appointmentDateController.text,
                        appointmentStatus:
                            widget.appointment?.appointmentStatus,
                        medicalRecordId: widget.appointment?.medicalRecordId,
                        paymentId: widget.appointment?.paymentId,
                      );

                      await viewModelNotifier.saveAppointment(appointment);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: const Text('حفظ'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
