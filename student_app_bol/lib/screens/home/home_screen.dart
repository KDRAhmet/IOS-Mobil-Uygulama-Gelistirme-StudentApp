import 'package:flutter/material.dart';
// Gerekli import'lar
import 'package:student_app_bol/screens/announcements/announcement_detail_screen.dart';
import 'package:student_app_bol/theme/app_theme.dart';
import 'package:student_app_bol/widgets/announcement_card.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:student_app_bol/screens/my_events/my_events_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigate;
  final String studentName;
  final String studentNumber;
  final int studentDbId;

  const HomeScreen({
    super.key,
    required this.onNavigate,
    required this.studentName,
    required this.studentNumber,
    required this.studentDbId,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, String>>> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    _announcementsFuture = _fetchAnnouncements();
  }

  String _createSnippet(String content) {
    if (content.length > 100) {
      return "${content.substring(0, 100)}...";
    }
    return content;
  }

  Future<List<Map<String, String>>> _fetchAnnouncements() async {
    const String apiUrl = "https://10.0.2.2:7072/api/AnnouncementsApi";
    try {
      final response = await http.get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) {
          String content = item["content"].toString();
          return {
            "title": item["title"].toString(),
            "date": item["createdAt"].toString(),
            "content": content,
            "snippet": _createSnippet(content),
          };
        }).toList();
      } else {
        throw Exception('API\'den veri alınamadı. Hata Kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API\'ye bağlanırken bir hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildWelcomeCard(context),
        const SizedBox(height: 24),

        Text(
          "Hızlı Erişim",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        _buildQuickAccessGrid(context),
        const SizedBox(height: 24),

        Text(
          "Son Duyurular",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        _buildAnnouncementsList(),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      color: ankaraUniversityBlue,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Merhaba, ${widget.studentName}",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Kampüse tekrar hoş geldin! Günü kaçırma.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.8),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    Widget buildQuickButton({required IconData icon, required String label, required VoidCallback onTap}) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: ankaraUniversityBlue),
              const SizedBox(height: 12),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        buildQuickButton(
          icon: Icons.calendar_today,
          label: "Ders Programı",
          onTap: () {
            widget.onNavigate(1);
          },
        ),
        buildQuickButton(
          icon: Icons.celebration,
          label: "Etkinlikler",
          onTap: () {
            widget.onNavigate(2);
          },
        ),
        buildQuickButton(
          icon: Icons.event_available,
          label: "Etkinliklerim",
          onTap: () {
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
        // --- YENİ EKLENDİ: Profilim Butonu ---
        // Boş durmasın diye buraya öğrenci bilgilerini gösteren bir buton ekledik.
        buildQuickButton(
          icon: Icons.person,
          label: "Profilim",
          onTap: () {
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
          },
        ),
      ],
    );
  }

  // Profil penceresi için yardımcı widget
  Widget _buildProfileInfo(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsList() {
    return FutureBuilder<List<Map<String, String>>>(
      future: _announcementsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ));
        }

        if (snapshot.hasError) {
          return Center(child: Text('Duyurular yüklenemedi: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          final allAnnouncements = snapshot.data!;
          final recentAnnouncements = allAnnouncements.take(3).toList();

          if (recentAnnouncements.isEmpty) {
            return const Center(child: Text("Gösterilecek duyuru bulunamadı."));
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentAnnouncements.length,
            itemBuilder: (context, index) {
              final announcement = recentAnnouncements[index];
              return AnnouncementCard(
                title: announcement["title"]!,
                snippet: announcement["snippet"]!,
                date: announcement["date"]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnnouncementDetailScreen(
                        title: announcement["title"]!,
                        date: announcement["date"]!,
                        content: announcement["content"]!,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }

        return const Center(child: Text("Bir sorun oluştu."));
      },
    );
  }
}