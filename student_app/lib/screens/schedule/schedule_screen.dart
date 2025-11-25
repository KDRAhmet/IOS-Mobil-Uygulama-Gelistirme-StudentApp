import 'package:flutter/material.dart';
// Gerekli import'lar
import 'package:student_app_bol/theme/app_theme.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Ders programı verisi için basit bir model sınıfı
// API'den gelen veriye göre güncelledim: professorName ekleyip, coloru kaldırdık
class Lesson {
  final String time;
  final String courseName;
  final String location;
  final String professorName; // API'den gelen yeni alan

  Lesson({
    required this.time,
    required this.courseName,
    required this.location,
    required this.professorName, // Constructor'a eklendi
  });
}

// StatelessWidget'ı StatefulWidget'a dönüştürüyoruz
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

// Animasyonlu TabController için 'SingleTickerProviderStateMixin' ekliyoruz
class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {

  // API'den gelen ve işlenen veriyi tutacak Future
  late Future<Map<String, List<Lesson>>> _scheduleFuture;
  late TabController _tabController;

  // Gün isimlerini API'den gelen (Türkçe) UI'daki (Kısaltma)
  // hale çevirmek için bir harita
  final Map<String, String> _dayMap = {
    "Pazartesi": "Pzt",
    "Salı": "Sal",
    "Çarşamba": "Çar",
    "Perşembe": "Per",
    "Cuma": "Cum",
    // Gerekirse Cumartesi, Pazar eklenebilir
  };

  @override
  void initState() {
    super.initState();
    // TabController'ı burada başlatıyoruz
    _tabController = TabController(length: 5, vsync: this); // 5 gün (Pzt-Cum)
    // Sayfa açılırken API'den verileri çek ve işle
    _scheduleFuture = _fetchAndProcessSchedule();
  }

  // API'den veriyi çeken ve işleyen ana fonksiyon
  Future<Map<String, List<Lesson>>> _fetchAndProcessSchedule() async {
    const String apiUrl = "https://10.0.2.2:7072/api/ScheduleApi";
    try {
      final response = await http.get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        // API'den gelen düz listeyi, günlere göre gruplayan fonksiyona gönder
        return _processApiData(data);
      } else {
        throw Exception('API\'den veri alınamadı. Hata Kodu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API\'ye bağlanırken bir hata oluştu: $e');
    }
  }

  // API'den gelen düz listeyi, UI'ın beklediği Map yapısına dönüştüren fonksiyon
  Map<String, List<Lesson>> _processApiData(List<dynamic> data) {
    // UI'da kullanılacak boş haritayı oluştur
    Map<String, List<Lesson>> groupedData = {
      "Pzt": [],
      "Sal": [],
      "Çar": [],
      "Per": [],
      "Cum": [],
    };

    // API'den gelen her bir ders için
    for (var item in data) {
      String scheduleTime = item["scheduleTime"]; // Örn: "Pazartesi 09:00 - 11:00"

      // "scheduleTime" alanını ayrıştır
      var parts = scheduleTime.split(' ');
      if (parts.length < 4) continue; // Hatalı veriyi atla

      String dayFullName = parts[0]; // "Pazartesi"
      String time = "${parts[1]} ${parts[2]} ${parts[3]}"; // "09:00 - 11:00"

      // Günün tam adını kısaltmaya çevir
      String? dayAbbr = _dayMap[dayFullName]; // "Pzt"

      if (dayAbbr != null && groupedData.containsKey(dayAbbr)) {
        // Yeni Lesson nesnesini oluştur
        Lesson lesson = Lesson(
          time: time,
          courseName: item["courseName"],
          location: item["location"],
          professorName: item["professorName"],
        );
        // Doğru günün listesine ekle
        groupedData[dayAbbr]!.add(lesson);
      }
    }

    return groupedData;
  }

  @override
  void dispose() {
    _tabController.dispose(); // Bellek sızıntısını önlemek için
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar'ı FutureBuilder'ın DIŞINDA bırakıyoruz ki hep görünsün
        TabBar(
          controller: _tabController,
          labelColor: ankaraUniversityBlue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Pzt'),
            Tab(text: 'Sal'),
            Tab(text: 'Çar'),
            Tab(text: 'Per'),
            Tab(text: 'Cum'),
          ],
        ),
        // TabBarView'ı FutureBuilder içine alıyoruz, çünkü veriye ihtiyacı var
        Expanded(
          child: FutureBuilder<Map<String, List<Lesson>>>(
            future: _scheduleFuture,
            builder: (context, snapshot) {
              // Yükleniyor...
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Hata oluştu...
              if (snapshot.hasError) {
                return Center(child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Ders programı yüklenemedi: ${snapshot.error}'),
                ));
              }

              // Veri başarıyla geldi...
              if (snapshot.hasData) {
                final scheduleData = snapshot.data!;
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildScheduleList(scheduleData["Pzt"]!),
                    _buildScheduleList(scheduleData["Sal"]!),
                    _buildScheduleList(scheduleData["Çar"]!),
                    _buildScheduleList(scheduleData["Per"]!),
                    _buildScheduleList(scheduleData["Cum"]!),
                  ],
                );
              }

              // Beklenmedik bir durum
              return const Center(child: Text("Bir sorun oluştu."));
            },
          ),
        ),
      ],
    );
  }

  // Gelen ders listesini widget'a dönüştüren fonksiyon
  Widget _buildScheduleList(List<Lesson> lessons) {
    if (lessons.isEmpty) {
      return const Center(
        child: Text(
          "Bugün için ders bulunmamaktadır.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.schedule, color: ankaraUniversityBlue),

                // Saati tek satırda gösteriyoruz ---
                Text(
                  lesson.time, // 'replaceAll' kaldırıldı
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11, // Fontu 1 tık küçülttük
                  ),
                ),
              ],
            ),
            title: Text(
              lesson.courseName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // Subtitle'a profesör ve konumu ekliyoruz
            subtitle: Text(
              "${lesson.professorName}\n${lesson.location}",
              style: TextStyle(color: Colors.grey[700]),
            ),
            isThreeLine: true, // Üç satırlı gösterime izin ver
          ),
        );
      },
    );
  }
}