import 'package:flutter/material.dart';
import 'package:student_app_bol/widgets/announcement_card.dart';
import 'package:student_app_bol/screens/announcements/announcement_detail_screen.dart';

import 'dart:async'; // Future için
import 'package:http/http.dart' as http; // HTTP paketi
import 'dart:convert'; // JSON çözmek için


class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late Future<List<Map<String, String>>> _announcementsFuture;

  @override
  void initState() {
    super.initState();


    // Veri çekme işlemini başlat
    _announcementsFuture = _fetchAnnouncements();
  }

  // --- Kendi 'snippet' (özet) alanımızı oluşturan fonksiyon ---
  String _createSnippet(String content) {
    if (content.length > 100) {
      return "${content.substring(0, 100)}...";
    }
    return content;
  }

  // --- API Çağrısını Gerçekleştiren Fonksiyon ---
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
    return FutureBuilder<List<Map<String, String>>>(
      future: _announcementsFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Veriler yüklenirken bir hata oluştu:\n\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          final announcements = snapshot.data!;

          if (announcements.isEmpty) {
            return const Center(
              child: Text("Gösterilecek duyuru bulunamadı."),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final announcement = announcements[index];
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

        return const Center(
          child: Text("Bir sorun oluştu."),
        );
      },
    );
  }
}