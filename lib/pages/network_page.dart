import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NetworkPage extends StatelessWidget {
  const NetworkPage({super.key});

  void _launchURL() async {
    final Uri url = Uri.parse('https://www.google.com/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka URL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Network & Browser")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _launchURL,
          icon: const Icon(Icons.open_in_browser),
          label: const Text("Buka Browser"),
        ),
      ),
    );
  }
}
