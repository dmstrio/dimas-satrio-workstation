import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final LatLng lokasiRumah = LatLng(-6.3478, 106.7385); // Pamulang, Tangsel

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  final List<FlSpot> visitData = [
    FlSpot(1, 3),
    FlSpot(4, 7),
    FlSpot(6, 5),
    FlSpot(10, 8),
    FlSpot(15, 4),
    FlSpot(20, 6),
    FlSpot(25, 10),
    FlSpot(30, 7),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage('assets/dimas.jpg') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: PopupMenuButton<ImageSource>(
                      icon: const Icon(Icons.camera_alt, color: Colors.blue),
                      onSelected: _pickImage,
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: ImageSource.camera,
                          child: Text('Ambil Foto'),
                        ),
                        const PopupMenuItem(
                          value: ImageSource.gallery,
                          child: Text('Pilih dari Galeri'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Dimas Satrio Nugroho',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Web Developer | PT Media Digital',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Statistik Kunjungan Bulanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: visitData,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      belowBarData:
                          BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Biodata',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            buildInfoRow('NIM', '211011402791'),
            buildInfoRow('Kampus', 'Universitas Pamulang'),
            buildInfoRow('Jurusan', 'Teknik Informatika'),
            buildInfoRow('Semester', '6'),
            const SizedBox(height: 24),
            const Text(
              'Lokasi Tempat Tinggal (Pamulang, Tangsel)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SizedBox(
              height: 250,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: lokasiRumah,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 60.0,
                        height: 60.0,
                        point: lokasiRumah,
                        child: const Icon(Icons.location_on,
                            size: 40, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Keahlian & Kegiatan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            buildBulletList([
              'Web Developer (Flutter & Laravel)',
              'Aktif di organisasi kampus dan panitia acara',
              'Komunikatif, bertanggung jawab, dan bisa kerja tim',
              'Public speaking & presentasi',
              'Pengalaman magang di PT Multi Akses Jaya',
            ]),
            const SizedBox(height: 24),
            const Text(
              'Proyek Terkait',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            buildProjectList([
              'Website Company Profile PT Multi Akses Jaya',
              'Aplikasi Perhitungan Luas Segitiga dengan Flutter',
              'Analisis Performa Cabang Perusahaan Retail (SQL)',
              'Sistem Penempatan Lokasi CCTV Viewer',
              'Presentasi & Kuis Interaktif tentang Compiler',
            ]),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget buildBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    const Text("\u2022 ", style: TextStyle(fontSize: 16)),
                    Expanded(
                        child:
                            Text(item, style: const TextStyle(fontSize: 16))),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget buildProjectList(List<String> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: projects
          .map((project) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text("\u2022 $project",
                    style: const TextStyle(fontSize: 16)),
              ))
          .toList(),
    );
  }
}
