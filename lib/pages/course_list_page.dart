import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/course.dart';
import '../models/meeting.dart';
import '../models/learning_module.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  _CourseListPageState createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  final List<Course> _courses = [
    Course(
      name: "Pemrograman Mobile",
      meetings: [
        Meeting(
          title: "Pertemuan 1",
          modules: [
            LearningModule(title: "Pengenalan Flutter", filePath: null),
          ],
        ),
      ],
    ),
    Course(
      name: "Basis Data",
      meetings: [
        Meeting(
          title: "Pertemuan 1",
          modules: [
            LearningModule(title: "Konsep Dasar SQL", filePath: null),
          ],
        ),
      ],
    ),
  ];

  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _meetingController = TextEditingController();
  final TextEditingController _moduleController = TextEditingController();

  void _addCourse() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tambah Mata Kuliah"),
        content: TextField(
          controller: _courseController,
          decoration: InputDecoration(hintText: "Nama Mata Kuliah"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              if (_courseController.text.isNotEmpty) {
                setState(() {
                  _courses.add(
                    Course(
                      name: _courseController.text,
                      meetings: [],
                    ),
                  );
                });
                _courseController.clear();
                Navigator.pop(context);
              }
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _addMeeting(int courseIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Tambah Pertemuan"),
        content: TextField(
          controller: _meetingController,
          decoration: InputDecoration(hintText: "Judul Pertemuan"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              if (_meetingController.text.isNotEmpty) {
                setState(() {
                  _courses[courseIndex].meetings.add(
                    Meeting(
                      title: _meetingController.text,
                      modules: [],
                    ),
                  );
                });
                _meetingController.clear();
                Navigator.pop(context);
              }
            },
            child: Text("Simpan"),
          ),
        ],
      ),
    );
  }

  Future<void> _addModule(int courseIndex, int meetingIndex) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'jpg', 'png'],
    );

    if (result != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Tambah Modul"),
          content: TextField(
            controller: _moduleController,
            decoration: InputDecoration(hintText: "Judul Modul"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                if (_moduleController.text.isNotEmpty) {
                  setState(() {
                    _courses[courseIndex].meetings[meetingIndex].modules.add(
                      LearningModule(
                        title: _moduleController.text,
                        filePath: result.files.single.path,
                      ),
                    );
                  });
                  _moduleController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text("Simpan"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Mata Kuliah"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addCourse,
            tooltip: "Tambah Mata Kuliah",
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, courseIndex) {
          final course = _courses[courseIndex];
          return Card(
            margin: EdgeInsets.all(8),
            child: ExpansionTile(
              leading: Icon(Icons.school, color: Colors.blue),
              title: Text(course.name, style: TextStyle(fontWeight: FontWeight.bold)),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("Pertemuan", 
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, size: 20),
                            onPressed: () => _addMeeting(courseIndex),
                            tooltip: "Tambah Pertemuan",
                          ),
                        ],
                      ),
                      ...course.meetings.map((meeting) {
                        final meetingIndex = course.meetings.indexOf(meeting);
                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Card(
                            margin: EdgeInsets.all(4),
                            child: ExpansionTile(
                              leading: Icon(Icons.meeting_room, color: Colors.green),
                              title: Text(meeting.title),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text("Modul Pembelajaran", 
                                                style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.add, size: 18),
                                            onPressed: () => _addModule(courseIndex, meetingIndex),
                                            tooltip: "Tambah Modul",
                                          ),
                                        ],
                                      ),
                                      ...meeting.modules.map((module) {
                                        return ListTile(
                                          leading: Icon(Icons.insert_drive_file, 
                                              color: module.filePath != null ? Colors.blue : Colors.grey),
                                          title: Text(module.title),
                                          subtitle: module.filePath != null 
                                              ? Text(module.filePath!.split('/').last)
                                              : Text("Belum ada file"),
                                          trailing: module.filePath != null
                                              ? IconButton(
                                                  icon: Icon(Icons.download),
                                                  onPressed: () {
                                                    _showFileOptions(module);
                                                  },
                                                )
                                              : null,
                                          onTap: () {
                                            if (module.filePath != null) {
                                              _showFileOptions(module);
                                            }
                                          },
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showFileOptions(LearningModule module) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.remove_red_eye),
              title: Text("Preview Modul"),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Membuka preview: ${module.title}");
              },
            ),
            ListTile(
              leading: Icon(Icons.download),
              title: Text("Download Modul"),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Mengunduh: ${module.filePath}");
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Bagikan Modul"),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Berbagi modul: ${module.title}");
              },
            ),
          ],
        );
      },
    );
  }
}