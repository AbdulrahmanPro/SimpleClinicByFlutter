import 'package:flutter/material.dart';
import 'package:test_provider_mvvm/model/doctors_dto.dart';
import 'package:test_provider_mvvm/model/person_model.dart';
import 'package:test_provider_mvvm/view/widgets/custom_text_field.dart';

class AddOrEditPersonAndDoctorDialog extends StatefulWidget {
  final void Function(PersonModel person, DoctorsDTO? doctor) onSubmit;
  final PersonModel? personModel;
  final DoctorsDTO? doctorsDTO;

  const AddOrEditPersonAndDoctorDialog({
    super.key,
    required this.onSubmit,
    this.personModel,
    this.doctorsDTO,
  });

  @override
  State<AddOrEditPersonAndDoctorDialog> createState() =>
      _AddOrEditPersonAndDoctorDialogState();
}

class _AddOrEditPersonAndDoctorDialogState
    extends State<AddOrEditPersonAndDoctorDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _specializationController;

  DateTime? _selectedDate;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.personModel?.personName ?? '');
    _phoneController =
        TextEditingController(text: widget.personModel?.phoneNumber ?? '');
    _emailController =
        TextEditingController(text: widget.personModel?.email ?? '');
    _addressController =
        TextEditingController(text: widget.personModel?.address ?? '');
    _selectedDate = widget.personModel?.dateOfBirth;
    _selectedGender = widget.personModel?.gender;
    _specializationController =
        TextEditingController(text: widget.doctorsDTO?.specialization ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() == true &&
        _selectedDate != null &&
        _selectedGender != null) {
      final person = PersonModel(
        id: widget.personModel?.id ?? 0,
        personName: _nameController.text.trim(),
        dateOfBirth: _selectedDate!,
        gender: _selectedGender!,
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
      );

      DoctorsDTO? doctor;
      if (_specializationController.text.trim().isNotEmpty) {
        doctor = DoctorsDTO(
          id: widget.doctorsDTO?.id ?? 0,
          personId: person.id,
          specialization: _specializationController.text.trim(),
        );
      }

      widget.onSubmit(person, doctor);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Dialog(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add / Edit Person',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  CustomTextField(
                      controller: _nameController,
                      label: 'Name',
                      icon: Icons.person),
                  _buildDatePicker(),
                  _buildGenderSelector(),
                  const SizedBox(height: 10),
                  CustomTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 10),
                  CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 10),
                  CustomTextField(
                      controller: _addressController,
                      label: 'Address',
                      icon: Icons.location_on),
                  const SizedBox(height: 10),
                  CustomTextField(
                      controller: _specializationController,
                      label: 'Specialization (Optional)',
                      icon: Icons.medical_services),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel')),
                      ElevatedButton(
                          onPressed: _handleSubmit, child: const Text('Save')),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(_selectedDate == null
            ? 'Select Date of Birth'
            : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[1]),
        TextButton.icon(
          icon: const Icon(Icons.date_range),
          onPressed: _pickDate,
          label: const Text('Pick Date'),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        const Text('Gender:'),
        Row(
          children: [
            Radio<String>(
                value: 'M',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value)),
            const Text('Male'),
            Radio<String>(
                value: 'F',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value)),
            const Text('Female'),
          ],
        ),
      ],
    );
  }
}
