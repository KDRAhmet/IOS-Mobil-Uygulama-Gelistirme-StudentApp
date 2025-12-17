import 'package:flutter/material.dart';

// Ana Renkler
const Color ankaraUniversityBlue = Color(0xFF1E3A8A); // Koyu Mavi
const Color ankaraUniversityYellow = Color(0xFFFBBF24); // Altın Sarısı
const Color lightGrey = Color(0xFFF3F4F6);
const Color darkGrey = Color(0xFF374151);

// --- AYDINLIK TEMA (Light Theme) ---
final ThemeData appTheme = ThemeData(
  primaryColor: ankaraUniversityBlue,
  scaffoldBackgroundColor: lightGrey,

  // AppBar Ayarları
  appBarTheme: const AppBarTheme(
    backgroundColor: ankaraUniversityBlue,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  // Alt Menü Ayarları
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: ankaraUniversityBlue,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),

  // Buton Ayarları
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ankaraUniversityBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  // Kart Ayarları
  // Not: Yeni Material (M3) sürümlerinde ThemeData.cardTheme artık CardThemeData bekleyebiliyor.
  // Bu yüzden CardTheme yerine CardThemeData kullanıyoruz.
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),

  // Metin Ayarları
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black87),
    titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
    headlineSmall:
    TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
  ),

  // Input Alanları (Login Ekranı için)
  inputDecorationTheme: InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    labelStyle: const TextStyle(color: Colors.black54),
    prefixIconColor: Colors.grey,
  ),
);

// --- KARANLIK TEMA (Dark Theme) ---
final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: ankaraUniversityBlue,
  scaffoldBackgroundColor: const Color(0xFF121212),

  // AppBar Ayarları (Koyu)
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
  ),

  // Alt Menü Ayarları (Koyu)
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1F1F1F),
    selectedItemColor: ankaraUniversityYellow,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
    type: BottomNavigationBarType.fixed,
  ),

  // Buton Ayarları
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ankaraUniversityBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  // Kart Ayarları (Koyu)
  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E1E),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  ),

  // Metin Ayarları (Koyu)
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white70),
    titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),

  // Input Alanları (Login Ekranı için)
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color(0xFF2C2C2C),
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    labelStyle: const TextStyle(color: Colors.white70),
    prefixIconColor: Colors.white70,
  ),
);
