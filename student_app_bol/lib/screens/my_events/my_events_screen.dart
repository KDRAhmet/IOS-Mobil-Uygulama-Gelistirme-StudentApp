import 'package:flutter/material.dart';
import 'package:student_app_bol/theme/app_theme.dart';
import 'package:student_app_bol/screens/events/events_screen.dart'; // Event modelini buradan kullanıyoruz
import 'package:student_app_bol/screens/events/event_detail_screen.dart'; // Detay ekranı için
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyEventsScreen extends StatefulWidget {
  // --- DEĞİŞİKLİK: Numara yerine ID kullanıyoruz ---
  final int studentDbId; // API sorgusu için
  final String studentNumber; // Detay ekranına geçiş için

  const MyEventsScreen({
    super.key,
    required this.studentDbId, // <-- ID
    required this.studentNumber, // <-- Numara
  });

  @override
  State<MyEventsScreen> createState() => _MyEventsScreenState();
}

class _MyEventsScreenState extends State<MyEventsScreen> {
  late Future<List<Event>> _myEventsFuture;

  @override
  void initState() {
    super.initState();
    _myEventsFuture = _fetchMyEvents();
  }

  Future<List<Event>> _fetchMyEvents() async {
    // --- ÖNEMLİ DEĞİŞİKLİK: API URL'si ---
    // Artık sorguyu ID (örn: 15) ile yapıyoruz.
    // Web API'nizde bu endpoint'in ID kabul ettiğinden emin olun.
    // Örnek: .../api/EventsApi/student/15
    final String apiUrl = "https://10.0.2.2:7072/api/EventsApi/student/${widget.studentDbId}";

    try {
      final response = await http.get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Event(
          id: item["id"],
          title: item["title"],
          description: item["description"],
          location: item["location"],
          eventDate: item["eventDate"],
        )).toList();
      } else {
        throw Exception('Etkinlikler alınamadı. Kod: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Hata oluştu: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etkinliklerim"),
      ),
      body: FutureBuilder<List<Event>>(
        future: _myEventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Bir hata oluştu:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            );
          }

          if (snapshot.hasData) {
            final events = snapshot.data!;
            if (events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    const Text("Henüz bir etkinliğe katılmadınız."),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green[100],
                      child: Icon(Icons.check, color: Colors.green[800]),
                    ),
                    title: Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      event.formattedDate,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventDetailScreen(
                            event: event,
                            studentDbId: widget.studentDbId,
                            studentNumber: widget.studentNumber,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }

          return const Center(child: Text("Bir sorun oluştu."));
        },
      ),
    );
  }
}