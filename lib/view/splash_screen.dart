import 'package:flutter/material.dart';
import 'package:test_provider_mvvm/view/Users/user_login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.tealAccent, Color.fromARGB(255, 23, 187, 185)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(20), // تحديد قيمة زاوية الدائرة
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/img2.webp'), // أو Image.network للرابط
                  fit: BoxFit.cover, // لضبط الصورة داخل الـ Container
                ),
              ),
              width: 300, // تحديد عرض الـ Container
              height: 300, // تحديد ارتفاع الـ Container
            ),
            const Text(
              'Smart Clinic',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(130, 50),
                  maximumSize: const Size(200, 150),
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: const Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
