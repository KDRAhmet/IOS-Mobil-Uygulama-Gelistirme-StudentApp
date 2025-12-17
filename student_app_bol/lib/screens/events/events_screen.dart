import 'package:flutter/material.dart';
// Gerekli import'lar
import 'package:student_app_bol/screens/events/event_detail_screen.dart';
import 'package:student_app_bol/theme/app_theme.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

// API'den gelen veriyi tutmak için bir model
class Event {
  final int id;
  final String title;
  final String description;
  final String location;
  final String eventDate;
  final String formattedDate;
  final String formattedTime;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.eventDate,
  }) : formattedDate = _formatDate(eventDate),
        formattedTime = _formatTime(eventDate);

  static String _formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat.yMMMMd('tr_TR').format(dateTime);
    } catch (e) {
      return "Tarih Yok";
    }
  }

  static String _formatTime(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat.Hm('tr_TR').format(dateTime);
    } catch (e) {
      return "Saat Yok";
    }
  }
}

// StatelessWidget'ı StatefulWidget'a dönüştürüyoruz
class EventsScreen extends StatefulWidget {
  // Login'den gelen ve MainScaffold'dan iletilen
  // öğrenci veritabanı ID'si VE numarası
  final int studentDbId;
  final String studentNumber;

  const EventsScreen({
    super.key,
    required this.studentDbId, // Constructor'a eklendi
    required this.studentNumber,
  });

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<Event>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = _fetchEvents();
  }

  Future<List<Event>> _fetchEvents() async {
    const String apiUrl = "https://10.0.2.2:7072/api/EventsApi";
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
        throw Exception('API\'den veri alınamadı. Hata Kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API\'ye bağlanırken bir hata oluştu: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Etkinlikler yüklenemedi: ${snapshot.error}'),
          ));
        }

        if (snapshot.hasData) {
          final events = snapshot.data!;
          if (events.isEmpty) {
            return const Center(
              child: Text(
                "Yakın zamanda bir etkinlik bulunmamaktadır.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
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
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.celebration, color: ankaraUniversityBlue),
                      const SizedBox(height: 4),
                      Text(
                        event.formattedTime,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: ankaraUniversityBlue,
                        ),
                      )
                    ],
                  ),
                  title: Text(
                    event.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${event.formattedDate}\n${event.location}",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    // Etkinlik detay ekranına yönlendir
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailScreen(
                          event: event,
                          studentDbId: widget.studentDbId,
                          // --- YENİ EKLENDİ: 'studentNumber'ı da detay ekranına iletiyoruz ---
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
    );
  }
}