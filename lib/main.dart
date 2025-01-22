import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_provider_mvvm/view/splash_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD App with MVVM & Riverpod',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: const Center(child: SplashScreen()),
    );
  }
}
