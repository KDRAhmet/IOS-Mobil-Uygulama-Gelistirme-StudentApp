import 'package:flutter/material.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String date;
  final String snippet;
  final VoidCallback? onTap; // Tıklama olayı için callback eklendi

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.date,
    required this.snippet,
    this.onTap, // Constructor'a eklendi
  });

  @override
  Widget build(BuildContext context) {
    // Kartı tıklanabilir yapmak için InkWell ile sarıyoruz
    return Card(
      clipBehavior: Clip.antiAlias, // Bu, tıklama efektinin köşelerden taşmamasını sağlar
      child: InkWell(
        onTap: onTap, // Tıklama olayını bağlıyoruz
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // İçerik Column ile düzgünce yerleştirildi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(date, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(snippet, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}