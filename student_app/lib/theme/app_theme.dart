import 'package:flutter/material.dart';

void main() {
  runApp(const StudentApp());
}

// ---- Renk Paleti ----
const Color ankaraUniversityBlue = Color(0xFF003366); // Koyu Mavi
const Color ankaraUniversityGold = Color(0xFFD4AF37); // Altın Sarısı
const Color lightGrey = Color(0xFFF5F5F5);            // Açık gri arkaplan

// ---- Tema ----
final ThemeData appTheme = ThemeData(
  primaryColor: ankaraUniversityBlue,
  // Modern yaklaşım: ColorScheme
  colorScheme: const ColorScheme.light(
    primary: ankaraUniversityBlue,
    secondary: ankaraUniversityGold,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    surface: Colors.white,
    background: lightGrey,
  ),
  scaffoldBackgroundColor: lightGrey,
  fontFamily: 'Poppins',

  // AppBar
  appBarTheme: const AppBarTheme(
    backgroundColor: ankaraUniversityBlue,
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Kart Teması CardThemeData
  cardTheme: const CardThemeData(
    elevation: 2,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),

  // Alt Navigasyon Çubuğu
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: ankaraUniversityBlue,
    unselectedItemColor: Colors.grey,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
    type: BottomNavigationBarType.fixed,
  ),

  // Metin Temaları (Material 3 isimleri)
  textTheme: TextTheme(
    headlineSmall: const TextStyle(
      fontWeight: FontWeight.bold,
      color: ankaraUniversityBlue,
    ),
    titleLarge: const TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      color: Colors.black.withOpacity(0.7),
    ),
  ),
);

// ---- Uygulama ----
class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Öğrenci Uygulaması',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // İçerideki widget'lar const olmadığı için listeyi const değil final yapıyoruz.
  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const SchedulePage(),
    const EventsPage(),
    const AnnouncementsPage(),
  ];

  final List<String> _pageTitles = const [
    "Ana Sayfa",
    "Ders Programı",
    "Etkinlikler",
    "Duyurular",
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_pageTitles[_selectedIndex])),
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Program'),
          BottomNavigationBarItem(icon: Icon(Icons.celebration), label: 'Etkinlikler'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Duyurular'),
        ],
      ),
    );
  }
}

// ---- Örnek Ekranlar ----
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text("Son Duyurular",
              style: Theme.of(context).textTheme.headlineSmall),
        ),
        _announcementCard(
          context,
          title: "Bahar Şenlikleri Başlıyor!",
          date: "10 Ekim 2025",
          snippet:
          "Mühendislik Fakültesi bahçesinde düzenlenecek olan bahar şenliklerine davetlisiniz...",
        ),
        _announcementCard(
          context,
          title: "Vize Tarihleri Açıklandı",
          date: "9 Ekim 2025",
          snippet:
          "2025-2026 Güz dönemi vize takvimi öğrenci işleri tarafından yayınlanmıştır...",
        ),
        _announcementCard(
          context,
          title: "Kütüphane Çalışma Saatleri",
          date: "8 Ekim 2025",
          snippet: "Final haftası boyunca kütüphanemiz 7/24 hizmet verecektir...",
        ),
      ],
    );
  }

  Widget _announcementCard(
      BuildContext context, {
        required String title,
        required String date,
        required String snippet,
      }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(date, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(snippet, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Ders Programı Ekranı',
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Etkinlikler Ekranı',
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Duyurular Ekranı',
          style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
