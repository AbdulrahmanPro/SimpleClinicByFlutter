import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_provider_mvvm/provider/user_login_provider.dart';
import 'package:test_provider_mvvm/view/Users/create_account.dart';
import 'package:test_provider_mvvm/view/widgets/custom_text_field.dart';
import 'package:test_provider_mvvm/view/home_screen.dart';

class LoginScreen extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _userName = TextEditingController();
  final _password = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(userLoginViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Screen'),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20), // تحديد قيمة زاوية الدائرة
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/images/images.jpeg'), // أو Image.network للرابط
                    fit: BoxFit.cover, // لضبط الصورة داخل الـ Container
                  ),
                ),
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _userName,
                label: 'User Name',
                icon: Icons.person,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _password,
                label: 'Password',
                icon: Icons.lock,
                isPassword: true,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true) {
                    ref
                        .read(userLoginViewModelProvider.notifier)
                        .login(_userName.text.trim(), _password.text.trim());
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    pref.setString('username', _userName.text);

                    if (loginState.value == true) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => OptionSelectionScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Invalid login credentials')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 80),
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CreateAccount()));
                },
                child: Text(
                  'Create Acount',
                  style: TextStyle(color: Colors.green[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
