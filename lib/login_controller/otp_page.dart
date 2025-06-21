import 'package:flutter/material.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();
  final String generatedOtp = "123456"; // Simulasi kode OTP

  @override
  void initState() {
    super.initState();
    // Tampilkan OTP saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showOtpPopup();
    });
  }

  void _showOtpPopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kode OTP Anda"),
        content: Text("Gunakan kode ini untuk login: $generatedOtp"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _verifyOtp() {
    if (otpController.text == generatedOtp) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode OTP salah")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Kode OTP telah dikirim ke nomor Anda.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: "Masukkan Kode OTP",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text("Verifikasi dan Masuk"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
