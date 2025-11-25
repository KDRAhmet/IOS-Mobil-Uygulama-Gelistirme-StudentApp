import 'package:flutter/material.dart';
// Gerekli import'lar
import 'package:student_app_bol/screens/announcements/announcement_detail_screen.dart';
import 'package:student_app_bol/theme/app_theme.dart';
import 'package:student_app_bol/widgets/announcement_card.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

// StatelessWidget'ı StatefulWidget'a dönüştürüyoruz
class HomeScreen extends StatefulWidget {
  // main_scaffold'dan gelen sekme değiştirme fonksiyonunu alabilmek için
  // bu parametreyi ekliyoruz.
  final Function(int) onNavigate;
  final String studentName; // Login'den gelen isim

  const HomeScreen({
    super.key,
    required this.onNavigate, // Constructor'a ekledik
    required this.studentName, //Constructor'a eklendi
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // API'den gelen veriyi tutmak için bir Future tanımlıyoruz
  late Future<List<Map<String, String>>> _announcementsFuture;

  @override
  void initState() {
    super.initState();
    // Sayfa açılırken API'den verileri çek
    _announcementsFuture = _fetchAnnouncements();
  }

  // --- Bu iki fonksiyonu announcements_screen.dart'tan kopyaladım ---

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
  // --- Kopyalanan fonksiyonların sonu ---


  @override
  Widget build(BuildContext context) {
    // Ana sayfa artık dikey bir liste
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // 1. Bileşen: Hoş Geldin Kartı
        _buildWelcomeCard(context),
        const SizedBox(height: 24),

        // 2. Bileşen: Hızlı Erişim Başlığı
        Text(
          "Hızlı Erişim",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        // 3. Bileşen: Hızlı Erişim Butonları
        _buildQuickAccessGrid(context),
        const SizedBox(height: 24),

        // 4. Bileşen: Son Duyurular Başlığı
        Text(
          "Son Duyurular",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),

        // 5. Bileşen: API'den Gelen Duyurular
        _buildAnnouncementsList(),
      ],
    );
  }


  // Hoş geldin kartını oluşturan fonksiyon
  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      color: ankaraUniversityBlue,
      elevation: 4, // Daha belirgin
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              //"Merhaba" -> "Merhaba, [İsim]" ---
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

  // Hızlı erişim butonlarını oluşturan fonksiyon
  Widget _buildQuickAccessGrid(BuildContext context) {
    // Butonlar için yardımcı bir fonksiyon
    Widget buildQuickButton({required IconData icon, required String label, required VoidCallback onTap}) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 2, // Hafif bir gölge
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
      shrinkWrap: true, // ListView içinde GridView kullanmak için
      physics: const NeverScrollableScrollPhysics(), // Kaydırmayı engelle
      childAspectRatio: 1.5, // Butonların en-boy oranı
      children: [
        buildQuickButton(
          icon: Icons.calendar_today,
          label: "Ders Programı",
          onTap: () {
            //1 numaralı (Ders Programı) sekmeye yönlendir ---
            widget.onNavigate(1);
          },
        ),
        buildQuickButton(
          icon: Icons.celebration,
          label: "Etkinlikler",
          onTap: () {
            // 2 numaralı (Etkinlikler) sekmeye yönlendir ---
            widget.onNavigate(2);
          },
        ),
        buildQuickButton(
          icon: Icons.school,
          label: "Notlarım", // Yeni bir özellik fikri
          onTap: () {
            // İleride eklenebilir
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notlarım özelliği yakında eklenecek.'))
            );
          },
        ),
        buildQuickButton(
          icon: Icons.restaurant_menu,
          label: "Yemekhane", // Yeni bir özellik fikri
          onTap: () {
            // İleride eklenebilir
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Yemekhane özelliği yakında eklenecek.'))
            );
          },
        ),
      ],
    );
  }

  // API'den gelen duyuruları listeleyen FutureBuilder
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
          // Ana sayfada sadece en son 3 duyuruyu alıyoruz
          final recentAnnouncements = allAnnouncements.take(3).toList();

          if (recentAnnouncements.isEmpty) {
            return const Center(child: Text("Gösterilecek duyuru bulunamadı."));
          }

          // ListView içinde bir başka ListView.builder KULLANILMAZ.
          // Bu yüzden shrinkWrap ve physics ayarları yapıyoruz.
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