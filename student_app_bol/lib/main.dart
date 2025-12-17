import 'package:flutter/material.dart';
import 'package:student_app_bol/screens/login/login_screen.dart';
import 'package:student_app_bol/theme/app_theme.dart';
import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';
// --- YENİ IMPORTLAR ---
import 'package:provider/provider.dart'; // Paket eklendikten sonra çalışır
import 'package:student_app_bol/theme/theme_provider.dart';

class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  HttpOverrides.global = _MyHttpOverrides();

  runApp(
    // Uygulamayı ThemeProvider ile sarmalıyoruz
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const StudentApp(),
    ),
  );
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provider'dan mevcut temayı dinliyoruz
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Öğrenci Portalı',

      // Temalarımızı bağlıyoruz
      themeMode: themeProvider.themeMode, // Aktif mod (Light/Dark/System)
      theme: appTheme, // Aydınlık tema ayarları
      darkTheme: appDarkTheme, // Karanlık tema ayarları

      home: const LoginScreen(),
    );
  }
}