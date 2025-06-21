import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import '../pages/profile_page.dart';
import '../pages/checkbox_page.dart';
import '../pages/course_list_page.dart';
import '../pages/tab_view_page.dart';
import '../pages/alert_toast_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

  final List<Widget> _pages = [
    const ProfilePage(),
    const CheckboxPage(),
    CourseListPage(),
    TabViewPage(),
    const AlertToastPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[currentPage],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentPage,
        onTap: (index) => setState(() => currentPage = index),
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
        ],
      ),
    );
  }
}
