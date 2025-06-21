import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart'; // Ganti import
import '../models/konten.dart';
import 'detail_page.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({super.key});

  @override
  _TabViewPageState createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Konten> _kontenList = [];

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _isiController = TextEditingController();
  final TextEditingController _nomorTeleponController = TextEditingController();

  String _selectedJenis = 'Artikel';
  final List<String> _kategoriList = [
    'Teknologi',
    'Olahraga',
    'Pendidikan',
    'Kesehatan',
    'Bisnis'
  ];

  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final granted = await telephony.requestPhoneAndSmsPermissions;
    if (!(granted ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permission SMS ditolak')),
      );
    }
  }

  void _submitKonten() {
    if (_formKey.currentState!.validate()) {
      final konten = Konten(
        jenis: _selectedJenis,
        judul: _judulController.text,
        kategori: _kategoriController.text,
        deskripsi: _deskripsiController.text,
        isi: _isiController.text,
      );

      setState(() {
        _kontenList.insert(0, konten);
        _sendSMS(konten);
        _judulController.clear();
        _kategoriController.clear();
        _deskripsiController.clear();
        _isiController.clear();
        _nomorTeleponController.clear();
      });
    }
  }

  void _sendSMS(Konten konten) async {
    final nomor = _nomorTeleponController.text;
    if (nomor.isEmpty) return;

    final isiPesan = "Judul: ${konten.judul}\n"
        "Jenis: ${konten.jenis}\n"
        "Kategori: ${konten.kategori}\n"
        "Deskripsi: ${konten.deskripsi}";

    await telephony.sendSms(
      to: nomor,
      message: isiPesan,
    );
  }

  void _showDetail(Konten konten) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(konten: konten),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artikel & Berita'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedJenis,
                    items: ['Artikel', 'Berita']
                        .map((jenis) => DropdownMenuItem(
                              value: jenis,
                              child: Text(jenis),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedJenis = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Jenis Konten',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _judulController,
                    decoration: InputDecoration(
                      labelText: 'Judul',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  SizedBox(height: 10),
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return _kategoriList.where((String option) {
                        return option
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                      _kategoriController.text = controller.text;
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Kategori',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Wajib diisi' : null,
                      );
                    },
                    onSelected: (String selection) {
                      _kategoriController.text = selection;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _deskripsiController,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi Singkat',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _isiController,
                    decoration: InputDecoration(
                      labelText: 'Konten Lengkap',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nomorTeleponController,
                    decoration: InputDecoration(
                      labelText: 'Kirim SMS ke Nomor',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Masukkan nomor tujuan' : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitKonten,
                    child: Text('Tambahkan & Kirim SMS'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(),
            Text('Daftar Konten', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _kontenList.length,
              itemBuilder: (context, index) {
                final konten = _kontenList[index];
                return ListTile(
                  title: Text(konten.judul),
                  subtitle: Text('${konten.jenis} | ${konten.kategori}'),
                  onTap: () => _showDetail(konten),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
