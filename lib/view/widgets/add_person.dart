import 'package:flutter/material.dart';
import 'package:test_provider_mvvm/model/person_model.dart';
import 'package:test_provider_mvvm/view/widgets/custom_text_field.dart';

class AddPersonDialog extends StatefulWidget {
  final void Function(PersonModel person) onSubmit;
  final PersonModel? personModel;

  const AddPersonDialog({super.key, required this.onSubmit, this.personModel});

  @override
  State<AddPersonDialog> createState() => _AddPersonDialogState();
}

class _AddPersonDialogState extends State<AddPersonDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  DateTime? _selectedDate;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();

    // تعبئة الحقول بالقيم إذا كانت موجودة
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
  }

  @override
  void dispose() {
    // تنظيف الموارد
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
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
    // التحقق من صحة البيانات وإرسالها
    if (_formKey.currentState?.validate() != false &&
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
      widget.onSubmit(person);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:
          Text(widget.personModel == null ? 'Add New Person' : 'Edit Person'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

  // مكون خاص لاختيار التاريخ
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

  // مكون خاص لتحديد الجنس
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
