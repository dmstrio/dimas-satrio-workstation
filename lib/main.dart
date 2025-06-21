import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'pages/profile_page.dart';
import 'pages/checkbox_page.dart';
import 'pages/course_list_page.dart';
import 'pages/tab_view_page.dart';
import 'pages/alert_toast_page.dart';
import 'login_controller/login_page.dart';
import 'login_controller/register_page.dart';
import 'login_controller/otp_page.dart'; // Tambahkan ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/main': (context) => const MainPage(),
        '/register': (context) => const RegisterPage(),
        '/otp': (context) => const OtpPage(), // Tambahkan route OTP
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

  final List<Widget> _pages = [
    const ProfilePage(),
    const CheckboxPage(),
    CourseListPage(),
    TabViewPage(),
    const AlertToastPage(),
    const NetworkPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPage],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentPage,
        onTap: (i) => setState(() => currentPage = i),
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("PROFILE"),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.check_box),
            title: const Text("TO - DO LIST"),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.list),
            title: const Text("COURSE"),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.tab),
            title: const Text("PUBLIKASI"),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.notifications),
            title: const Text("ALARM"),
            selectedColor: Colors.blue,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.public),
            title: const Text("NETWORK"),
            selectedColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

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
