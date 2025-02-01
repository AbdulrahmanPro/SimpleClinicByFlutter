import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_provider_mvvm/view/Users/user_login.dart';
import 'package:test_provider_mvvm/view/Users/user_view.dart';
import 'package:test_provider_mvvm/view/appointment/appointment_view.dart';
import 'package:test_provider_mvvm/view/doctor/doctor_view.dart';
import 'package:test_provider_mvvm/view/patients/patient_view.dart';
import 'package:test_provider_mvvm/provider/user_login_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Guest';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userLoginViewModelProvider);

    return Drawer(
      child: FutureBuilder<String>(
        future: _getUsername(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final String username = snapshot.data!;
          final bool isAdmin = username == 'admin@gmail.com';

          return Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
                accountName: Text(
                  username,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                accountEmail: const Text(
                  'example@email.com',
                  style: TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.green),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    if (isAdmin)
                      _buildDrawerItem(
                        icon: Icons.people,
                        text: 'Users',
                        onTap: () => _navigateTo(context, const UserView()),
                      ),
                    _buildDrawerItem(
                      icon: Icons.local_hospital,
                      text: 'Doctors',
                      onTap: () => _navigateTo(context, const DoctorScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.sick,
                      text: 'Patients',
                      onTap: () => _navigateTo(context, const PatientScreen()),
                    ),
                    _buildDrawerItem(
                      icon: Icons.calendar_today,
                      text: 'Appointment',
                      onTap: () =>
                          _navigateTo(context, const AppointmentView()),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      onTap: () => _showLogoutDialog(context, ref),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.green[700]),
      title: Text(text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      onTap: onTap,
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final bool? confirmLogout = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('username');
              ref.read(userLoginViewModelProvider.notifier).logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
