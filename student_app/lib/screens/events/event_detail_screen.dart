import 'package:flutter/material.dart';
import 'package:student_app_bol/screens/events/events_screen.dart'; // Event modelini import etmek için
import 'package:student_app_bol/theme/app_theme.dart'; // Temamızı import etmek için
import 'dart:async'; // Asenkron işlemler için
import 'package:http/http.dart' as http; // HTTP paketi
import 'dart:convert'; // JSON işlemleri için

// StatelessWidget'ı StatefulWidget'a dönüştürüyoruz
class EventDetailScreen extends StatefulWidget {
  final Event event; // 'events_screen.dart' dosyasından gelen Event nesnesi

  // Login'den gelen ve EventsScreen'den iletilen
  // öğrenci veritabanı ID'si VE numarası
  final int studentDbId;
  final String studentNumber;

  const EventDetailScreen({
    super.key,
    required this.event,
    required this.studentDbId,
    required this.studentNumber, // <-- YENİ EKLENDİ
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isLoading = false;
  bool _isJoined = false;
  String _errorMessage = '';

  //Etkinliğe katılmak için API'ye POST isteği ---
  Future<void> _joinEvent() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String apiUrl = "https://10.0.2.2:7072/api/EventsApi/join/${widget.event.id}";

    //API'ye 'studentNumber' gönderiyoruz ---
    // Web API'ne öğrenci numarasını JSON body içinde gönderiyoruz
    final body = json.encode({
      'studentNumber': widget.studentNumber, // 'studentId' yerine 'studentNumber'
      'eventId': widget.event.id
    });

    // [HttpPost("join/{eventId}")] fonksiyonunun [FromBody] ile
    // bir 'studentNumber' beklediğinden emin ol.

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Başarılı
        setState(() {
          _isJoined = true;
        });
      } else {
        // API'den hata döndü (405, 400, 500 vb.)
        throw Exception('Katılma işlemi başarısız. Hata Kodu: ${response.statusCode}');
      }
    } catch (e) {
      // Bağlantı hatası veya zaman aşımı
      setState(() {
        _errorMessage = 'Bir hata oluştu: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Etkinlik Detayı"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Etkinlik Başlığı
              Text(
                widget.event.title,
                style: Theme.of(buildContext).textTheme.headlineSmall?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 24.0),

              // --- Detay Bilgi Kartları ---
              _buildDetailRow(
                buildContext,
                icon: Icons.calendar_today,
                title: "Tarih",
                content: widget.event.formattedDate,
              ),
              _buildDetailRow(
                buildContext,
                icon: Icons.schedule,
                title: "Saat",
                content: widget.event.formattedTime,
              ),
              _buildDetailRow(
                buildContext,
                icon: Icons.location_on,
                title: "Konum",
                content: widget.event.location,
              ),

              const SizedBox(height: 16.0),
              Divider(color: Colors.grey[300]), // Ayırıcı çizgi
              const SizedBox(height: 16.0),

              // Etkinlik Açıklaması
              Text(
                "Açıklama",
                style: Theme.of(buildContext).textTheme.titleLarge?.copyWith(
                    color: ankaraUniversityBlue
                ),
              ),
              const SizedBox(height: 12.0),
              Text(
                widget.event.description,
                style: Theme.of(buildContext).textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.5),
              ),

              // --- Dinamik "Katıl" Butonu ---
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: _isLoading
                      ? Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(2.0),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      : Icon(_isJoined ? Icons.check_circle : Icons.check_circle_outline),

                  label: Text(
                      _isLoading ? "KATILINIYOR..." : (_isJoined ? "KATILDIN!" : "ETKİNLİĞE KATIL")
                  ),

                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: _isJoined ? Colors.green[600] : ankaraUniversityBlue,
                    disabledBackgroundColor: _isJoined ? Colors.green[600] : Colors.grey,
                  ),

                  onPressed: (_isLoading || _isJoined) ? null : _joinEvent,
                ),
              ),

              // Hata mesajı (eğer varsa)
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // Detay satırları için yardımcı bir widget
  Widget _buildDetailRow(BuildContext context, {required IconData icon, required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: ankaraUniversityBlue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}