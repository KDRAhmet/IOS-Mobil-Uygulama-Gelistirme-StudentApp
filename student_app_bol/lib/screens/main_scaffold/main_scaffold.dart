import 'package:flutter/material.dart';
// Proje paket adını (student_app_bol) kullanarak import ediyoruz
import 'package:student_app_bol/screens/announcements/announcements_screen.dart';
import 'package:student_app_bol/screens/events/events_screen.dart';
import 'package:student_app_bol/screens/home/home_screen.dart';
import 'package:student_app_bol/screens/schedule/schedule_screen.dart';
import 'package:student_app_bol/theme/app_theme.dart';
import 'package:student_app_bol/screens/my_events/my_events_screen.dart';
import 'package:student_app_bol/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:student_app_bol/theme/theme_provider.dart';

class MainScaffold extends StatefulWidget {
  final int studentDbId;
  final String studentName;
  final String studentNumber;

  const MainScaffold({
    super.key,
    required this.studentDbId,
    required this.studentName,
    required this.studentNumber,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();

    _widgetOptions = <Widget>[
      HomeScreen(
        onNavigate: _onItemTapped,
        studentName: widget.studentName,
        studentNumber: widget.studentNumber,
        studentDbId: widget.studentDbId,
      ),
      const ScheduleScreen(),
      EventsScreen(
        studentDbId: widget.studentDbId,
        studentNumber: widget.studentNumber,
      ),
      const AnnouncementsScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _pageTitles = [
    "Ana Sayfa",
    "Ders Programı",
    "Etkinlikler",
    "Duyurular"
  ];

  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.badge, color: ankaraUniversityBlue),
              const SizedBox(width: 8),
              const Text("Öğrenci Bilgileri"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileInfo("Ad Soyad", widget.studentName),
              const SizedBox(height: 8),
              _buildProfileInfo("Öğrenci No", widget.studentNumber),
              const SizedBox(height: 8),
              _buildProfileInfo("Sistem ID", widget.studentDbId.toString()),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Kapat"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: textColor),
        children: [
          TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Çıkış Yap"),
        content: const Text("Hesabınızdan çıkış yapmak istediğinize emin misiniz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("İptal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text("Çıkış Yap", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ThemeProvider'a erişim
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        // --- DEĞİŞİKLİK: Sağ üst köşeye Karanlık Mod ikonu eklendi ---
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: () {
              // Tıklandığında modu tersine çevir
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
            tooltip: themeProvider.isDarkMode ? "Aydınlık Mod" : "Karanlık Mod",
          ),
        ],
        // --- DEĞİŞİKLİK SONU ---
      ),

      // --- YENİ EKLENDİ: Yan Menü (Drawer) ---
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Başlığı
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: ankaraUniversityBlue,
              ),
              accountName: Text(
                widget.studentName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(
                "Öğrenci No: ${widget.studentNumber}",
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),

            // 1. Profilim
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profilim'),
              onTap: () {
                Navigator.pop(context); // Drawer'ı kapat
                _showProfileDialog();
              },
            ),

            // 2. Duyurular (Index 3)
            ListTile(
              leading: const Icon(Icons.campaign),
              title: const Text('Duyurular'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(3);
              },
            ),

            // 3. Etkinliklerim (Ayrı Sayfa)
            ListTile(
              leading: const Icon(Icons.event_available),
              title: const Text('Etkinliklerim'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyEventsScreen(
                      studentDbId: widget.studentDbId,
                      studentNumber: widget.studentNumber,
                    ),
                  ),
                );
              },
            ),

            // 4. Tüm Etkinlikler (Index 2)
            ListTile(
              leading: const Icon(Icons.celebration),
              title: const Text('Tüm Etkinlikler'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),

            // 5. Ders Programı (Index 1) - İsteğin üzerine eklendi
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Ders Programı'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),

            const Spacer(), // Aradaki boşluğu doldurur
            const Divider(),

            // 6. Çıkış Yap
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Çıkış Yap', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      // --- DRAWER SONU ---

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Program',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.celebration),
            label: 'Etkinlikler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.campaign),
            label: 'Duyurular',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}