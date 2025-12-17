import 'package:flutter/material.dart';

class AnnouncementDetailScreen extends StatelessWidget {
  final String title;
  final String date;
  final String content;

  const AnnouncementDetailScreen({
    super.key,
    required this.title,
    required this.date,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Duyuru Detayı"), // Sabit bir başlık
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Duyuru Başlığı
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 12.0),
              // Tarih Bilgisi
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    date,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              // Duyurunun tam içeriği
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}