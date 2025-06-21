import 'package:flutter/material.dart';
import '../models/konten.dart';

class DetailPage extends StatelessWidget {
  final Konten konten;

  const DetailPage({super.key, required this.konten});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(konten.judul),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(konten.jenis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Text(konten.kategori, style: TextStyle(fontSize: 14, color: Colors.grey)),
            Divider(height: 20),
            Text(konten.deskripsi, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text(konten.isi, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}