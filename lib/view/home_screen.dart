import 'package:flutter/material.dart';
import 'package:test_provider_mvvm/data/repositories/appointment_repository.dart';
import 'package:test_provider_mvvm/view/Persons/person_view.dart';
import 'package:test_provider_mvvm/view/Users/user_view.dart';
import 'package:test_provider_mvvm/view/appointment/appointment_view.dart';
import 'package:test_provider_mvvm/view/doctor/doctor_view.dart';
import 'package:test_provider_mvvm/view/patients/patient_view.dart';

class OptionSelectionScreen extends StatelessWidget {
  final List<String> options = [
    'Users',
    'Doctors',
    'Persons',
    'Patients',
    'Appointment'
  ];

  OptionSelectionScreen({super.key});
  Widget _chooseScreen(String option) {
    switch (option) {
      case 'Users':
        return const UserView();
      case 'Doctors':
        return const DoctorScreen();
      case 'Persons':
        return const PersonListScreen();
      case 'Patients':
        return const PatientScreen();
      case 'Appointment':
       return  const AppointmentView();
      default:
        return const Text('Invalid option selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select an Option')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            child: InkWell(
              onTap: () {
                String selectedOption = options[index];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => _chooseScreen(selectedOption)),
                );
              },
              child: Center(
                child: Text(
                  options[index],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
