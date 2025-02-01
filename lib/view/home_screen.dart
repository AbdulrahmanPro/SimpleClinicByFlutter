import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_provider_mvvm/view/Users/user_view.dart';
import 'package:test_provider_mvvm/view/appointment/appointment_view.dart';
import 'package:test_provider_mvvm/view/doctor/doctor_view.dart';
import 'package:test_provider_mvvm/view/patients/patient_view.dart';
import 'package:test_provider_mvvm/view/widgets/drawer.dart';

class OptionSelectionScreen extends StatelessWidget {
  OptionSelectionScreen({super.key});

  final List<Map<String, dynamic>> allOptions = [
    {'title': 'Users', 'icon': Icons.people, 'screen': const UserView()},
    {
      'title': 'Doctors',
      'icon': Icons.local_hospital,
      'screen': const DoctorScreen()
    },
    {'title': 'Patients', 'icon': Icons.sick, 'screen': const PatientScreen()},
    {
      'title': 'Appointment',
      'icon': Icons.calendar_today,
      'screen': const AppointmentView()
    },
  ];

  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Guest';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select an Option'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<String>(
        future: _getUsername(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final String username = snapshot.data!;
          final List<Map<String, dynamic>> filteredOptions =
              username == 'admin@gmail.com'
                  ? allOptions
                  : allOptions
                      .where((option) => option['title'] != 'Users')
                      .toList();

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: filteredOptions.length,
              itemBuilder: (context, index) {
                final option = filteredOptions[index];

                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: Colors.green[100],
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => option['screen']),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    splashColor: Colors.green.withOpacity(0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(option['icon'],
                            size: 40, color: Colors.green[700]),
                        const SizedBox(height: 10),
                        Text(
                          option['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
