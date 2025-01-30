import 'package:flutter/material.dart';
import 'package:test_provider_mvvm/view/Users/user_view.dart';
import 'package:test_provider_mvvm/view/appointment/appointment_view.dart';
import 'package:test_provider_mvvm/view/doctor/doctor_view.dart';
import 'package:test_provider_mvvm/view/patients/patient_view.dart';
import 'package:test_provider_mvvm/view/widgets/drawer.dart';

class OptionSelectionScreen extends StatelessWidget {
  OptionSelectionScreen({super.key});

  // 🟢 تعريف الخيارات مع الأيقونات
  final List<Map<String, dynamic>> options = [
    {'title': 'Users', 'icon': Icons.people, 'screen': const UserView()},
    {'title': 'Doctors', 'icon': Icons.local_hospital, 'screen': const DoctorScreen()},
    {'title': 'Patients', 'icon': Icons.sick, 'screen': const PatientScreen()},
    {'title': 'Appointment', 'icon': Icons.calendar_today, 'screen': const AppointmentView()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select an Option')),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2, // 📌 تحسين تناسب العناصر
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];

            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // 🔹 زوايا دائرية
              ),
              color: Colors.green[100], // 🎨 لون الخلفية
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => option['screen']),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                splashColor: Colors.green.withOpacity(0.2), // 💦 تأثير الضغط
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      option['icon'],
                      size: 40,
                      color: Colors.green[700], // 🎨 لون الأيقونة
                    ),
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
      ),
    );
  }
}
