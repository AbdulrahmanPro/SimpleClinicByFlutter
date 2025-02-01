import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/model/person_model.dart';
import 'package:test_provider_mvvm/model/usermodel.dart';
import 'package:test_provider_mvvm/provider/user_provider.dart';
import 'package:test_provider_mvvm/view/Users/user_login.dart';
import 'package:test_provider_mvvm/view/widgets/custom_text_field.dart';
import 'package:test_provider_mvvm/provider/person_provider.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  DateTime? _selectedDate;

  String? _selectedGender;

  @override
  void dispose() {
    // تنظيف الموارد
    _nameController.dispose();
    _phoneController.dispose();
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

  // مكون خاص لاختيار التاريخ
  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
            _selectedDate == null
                ? 'Select Date of Birth'
                : 'Date: ${_selectedDate!.toLocal()}'.split(' ')[1],
            style: const TextStyle(fontSize: 15)),
        TextButton.icon(
          icon: const Icon(Icons.date_range),
          onPressed: () => _pickDate(context),
          label: const Text('Pick Date', style: TextStyle(fontSize: 18)),
        ),
      ],
    );
  }

  // مكون خاص لتحديد الجنس
  Widget _buildGenderSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Gender:',
          style: TextStyle(fontSize: 18),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Radio<String>(
                value: 'M',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const Text('Male', style: TextStyle(fontSize: 16)),
              Radio<String>(
                value: 'F',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              const Text('Female', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  bool _handleSubmit() {
    // التحقق من صحة البيانات وإرسالها
    if (_formKey.currentState?.validate() != false &&
        _selectedDate != null &&
        _selectedGender != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SingleChildScrollView(
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
                    controller: _addressController,
                    label: 'Address',
                    icon: Icons.location_on,
                    validator: (value) => value?.isEmpty == true
                        ? 'Please enter an address'
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_circle_left,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_handleSubmit()) {
                    final PersonModel personModel = PersonModel(
                        id: 0,
                        personName: _nameController.text,
                        dateOfBirth: _selectedDate!,
                        gender: _selectedGender!,
                        phoneNumber: _phoneController.text,
                        email: '',
                        address: _addressController.text);
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            UserInputScreen(
                          personModel: personModel,
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.arrow_circle_right,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInputScreen extends ConsumerWidget {
  UserInputScreen({super.key, required this.personModel});
  final PersonModel personModel;

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final _formKeyUser = GlobalKey<FormState>();

  bool _handleSubmit() {
    // التحقق من صحة البيانات وإرسالها
    if (_formKeyUser.currentState?.validate() != false) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personprovider = ref.watch(personViewModelProvider.notifier);
    final userProvider = ref.watch(userViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Input Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          child: Form(
            key: _formKeyUser,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter an email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value!)) {
                      return 'Invalid email format';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock,
                  iconStrategy: PasswordIconStrategy(),
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  icon: Icons.lock,
                  keyboardType: TextInputType.visiblePassword,
                  iconStrategy: PasswordIconStrategy(),
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: const Text('back'),
                        icon: const Icon(
                          Icons.arrow_circle_left,
                          size: 32,
                          color: Colors.blue,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          if (_handleSubmit()) {
                            personModel.email = _emailController.text;
                            final int id =
                                await personprovider.createPerson(personModel);
                            {
                              if (id != -1) {
                                final userModel = UserModel(
                                    id: 0,
                                    personId: id,
                                    name: personModel.personName,
                                    userName: _emailController.text,
                                    password: _confirmPasswordController.text);
                                await userProvider.createUser(userModel);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => LoginScreen()));
                              }
                            }
                          }
                        },
                        label: const Text('add'),
                        icon: const Icon(
                          Icons.add,
                          size: 32,
                          color: Colors.blue,
                        ),
                      ),
                    ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
