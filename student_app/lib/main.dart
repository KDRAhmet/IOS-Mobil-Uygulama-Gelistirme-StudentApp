import 'package:flutter/material.dart';
import 'package:student_app_bol/app.dart'; // Proje paket adını (student_app_bol) kullanıyoruz
import 'dart:io'; // HTTPS (SSL) çözümü için

// --- YENİ EKLENDİ: Tarih formatlaması için ---
import 'package:intl/date_symbol_data_local.dart';

// --- HTTPS/SSL Geliştirme Hatası Çözümü ---
class _MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// --- DEĞİŞİKLİK: main() fonksiyonu 'async' oldu ---
void main() async {

  // --- YENİ EKLENDİ: Flutter binding'lerinin hazır olduğundan emin ol ---
  // Await kullandığımız için bu satır zorunludur.
  WidgetsFlutterBinding.ensureInitialized();

  // --- YENİ EKLENDİ: 'intl' paketini Türkçe için başlat ---
  // Bu satır, 'DateFormat.yMMMMd('tr_TR')' gibi formatların
  // çalışmasını ve "Tarih Yok" hatasını çözmesini sağlayacak.
  await initializeDateFormatting('tr_TR', null);

  // --- HTTPS Çözümünü aktifleştir ---
  HttpOverrides.global = _MyHttpOverrides();

  // Uygulamayı çalıştır
  runApp(const StudentApp());
}