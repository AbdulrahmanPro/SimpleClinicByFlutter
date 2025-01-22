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

  // Controllers for person fields
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  // Controllers for doctor fields
  late TextEditingController _specializationController;

  DateTime? _selectedDate;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();

    // Initialize person fields
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

    // Initialize doctor fields
    _specializationController =
        TextEditingController(text: widget.doctorsDTO?.specialization ?? '');
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() == true &&
        _selectedDate != null &&
        _selectedGender != null) {
      // Create person object
      final person = PersonModel(
        id: widget.personModel?.id ?? 0,
        personName: _nameController.text.trim(),
        dateOfBirth: _selectedDate!,
        gender: _selectedGender!,
        phoneNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
      );

      // Create doctor object only if specialization is provided
      DoctorsDTO? doctor;
      if (_specializationController.text.trim().isNotEmpty) {
        doctor = DoctorsDTO(
          id: widget.doctorsDTO?.id ?? 0,
          personId: person.id, // Will be used after saving person
          specialization: _specializationController.text.trim(),
        );
      }

      // Pass both models back to the parent
      widget.onSubmit(person, doctor);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.personModel == null
          ? 'Add New Person'
          : 'Edit Person & Doctor'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Person Fields
              CustomTextField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 10),
              _buildDatePicker(),
              const SizedBox(height: 10),
              _buildGenderSelector(),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => value?.isEmpty == true
                    ? 'Please enter a phone number'
                    : null,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty == true) return 'Please enter an email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value!)) {
                    return 'Invalid email format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on,
                validator: (value) =>
                    value?.isEmpty == true ? 'Please enter an address' : null,
              ),
              const Divider(),
              // Doctor Fields
              CustomTextField(
                controller: _specializationController,
                label: 'Specialization (Optional)',
                icon: Icons.medical_services,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleSubmit,
          child: Text(widget.personModel == null ? 'Create' : 'Update'),
        ),
      ],
    );
  }

  // Date picker widget
  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _selectedDate == null
              ? 'Select Date of Birth'
              : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[1],
        ),
        TextButton.icon(
          icon: const Icon(Icons.date_range),
          onPressed: () => _pickDate(context),
          label: const Text('Pick Date'),
        ),
      ],
    );
  }

  // Gender selector widget
  Widget _buildGenderSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text('Gender:'),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Radio<String>(
                value: 'M',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const Text('Male'),
              Radio<String>(
                value: 'F',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const Text('Female'),
            ],
          ),
        ),
      ],
    );
  }
}
