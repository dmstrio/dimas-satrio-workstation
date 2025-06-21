import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';


class AlertToastPage extends StatefulWidget {
  const AlertToastPage({super.key});

  @override
  _AlertToastPageState createState() => _AlertToastPageState();
}

class _AlertToastPageState extends State<AlertToastPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah ingin menampilkan notifikasi?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _showToast();
                Navigator.pop(context);
              },
              child: Text("Ya", style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Tidak", style: TextStyle(fontSize: 18, color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showToast() {
    String message = _controller.text.isNotEmpty ? _controller.text : "Notifikasi Default";
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _setReminder() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(seconds: 5), () {
      Fluttertoast.showToast(
        msg: "\u23F0 Waktu Mengingat Sesuatu!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Pengingat disetel dalam 5 detik..."),
        duration: Duration(seconds: 5),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ALARM PENGINGAT BANGUN")),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Masukkan Input Ketika Pengingat Berbunyi",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showAlertDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                foregroundColor: Colors.white
              ),
              child: Text("Tampilkan Pengingat"),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _setReminder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
                foregroundColor: Colors.white
              ),
              child: Text("Pasang Pengingat"),
            ),
          ],
        ),
      ),
    );
  }
}