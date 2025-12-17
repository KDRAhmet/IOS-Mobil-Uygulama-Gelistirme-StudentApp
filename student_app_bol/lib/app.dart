import 'package:flutter/material.dart';
import 'package:student_app_bol/screens/login/login_screen.dart';
import 'package:student_app_bol/theme/app_theme.dart';

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Öğrenci Uygulaması',
      theme: appTheme, // Tema artık app_theme.dart dosyasından geliyor
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(), // Başlangıç ekranı login_screen.dart'tan geliyor
    );
  }
}