import 'package:flutter/material.dart';

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  _CheckboxPageState createState() => _CheckboxPageState();
}

class _CheckboxPageState extends State<CheckboxPage> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDeadline;
  bool _isLoading = false;

  void _addTask() async {
    if (_taskController.text.isNotEmpty && _selectedDeadline != null) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 1)); // simulasi loading

      setState(() {
        _tasks.add({
          'title': _taskController.text,
          'deadline': _selectedDeadline!,
          'done': false,
        });
        _taskController.clear();
        _selectedDeadline = null;
        _isLoading = false;
      });
    }
  }

  void _checkDeadline() {
    final now = DateTime.now();
    for (var task in _tasks) {
      if (!task['done'] && task['deadline'].isBefore(now)) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Tenggat Waktu Terlewati!"),
              content: Text("Tugas '${task['title']}' sudah melewati tenggat waktu."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            ),
          );
        });
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkDeadline());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("To-Do List")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: "Nama Tugas",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    if (date != null) {
                      setState(() {
                        _selectedDeadline = date;
                      });
                    }
                  },
                  child: const Text("Pilih Tenggat"),
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedDeadline != null
                      ? "${_selectedDeadline!.toLocal()}".split(' ')[0]
                      : "Belum dipilih",
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _addTask,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Tambah Tugas"),
            ),
            const Divider(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        task['title'],
                        style: TextStyle(
                          decoration: task['done']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                        "Tenggat: ${task['deadline'].toLocal()}".split(' ')[0],
                      ),
                      trailing: Wrap(
                        spacing: 12,
                        children: [
                          Checkbox(
                            value: task['done'],
                            onChanged: (bool? value) {
                              setState(() {
                                task['done'] = value ?? false;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _tasks.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
