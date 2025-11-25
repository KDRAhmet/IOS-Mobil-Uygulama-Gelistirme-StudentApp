import 'package:flutter/material.dart';
// Proje paket adını (student_app_bol) kullanarak import ediyoruz
import 'package:student_app_bol/screens/announcements/announcements_screen.dart';
import 'package:student_app_bol/screens/events/events_screen.dart';
import 'package:student_app_bol/screens/home/home_screen.dart';
import 'package:student_app_bol/screens/schedule/schedule_screen.dart';

class MainScaffold extends StatefulWidget {
  // LoginScreen'den gelen öğrenci bilgilerini almak için
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

    // Listeyi burada başlatıyoruz
    _widgetOptions = <Widget>[
      //Verileri alt ekranlara iletiyoruz
      HomeScreen(
        onNavigate: _onItemTapped,
        studentName: widget.studentName,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
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