import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  List<String> _tasks = [];
  Map<String, List<Map<String, dynamic>>> _nestedTasks = {
    'Monday': [
      {
        'time': '9 am - 10 am',
        'tasks': ['HW1', 'Essay2']
      },
      {
        'time': '12 pm - 2 pm',
        'tasks': ['Project A', 'Read Chapter 5']
      },
    ],
    'Tuesday': [
      {
        'time': '10 am - 11 am',
        'tasks': ['Meeting', 'Exercise']
      },
      {
        'time': '3 pm - 4 pm',
        'tasks': ['Research', 'Notes']
      },
    ],
    // Add more days and tasks as needed
  };

  void _add() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
      });
      _taskController.clear();
    }
  }

  void _delete(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Enter Task Name',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _add,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ..._tasks.asMap().entries.map((entry) {
                  int index = entry.key;
                  String task = entry.value;
                  return ListTile(
                    title: Text(task),
                    leading: Checkbox(
                      value: false,
                      onChanged: (value) {
                        setState(() {
                          // TODO Mark task as complete or incomplete
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _delete(index),
                    ),
                  );
                }).toList(),
                ..._nestedTasks.keys.map((day) {
                  return ExpansionTile(
                    title: Text(day,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    children: _nestedTasks[day]!.map((schedule) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(schedule['time'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600)),
                            ...schedule['tasks'].map<Widget>((subTask) {
                              return ListTile(
                                title: Text(subTask),
                                leading: Checkbox(
                                  value: false,
                                  onChanged: (value) {
                                    setState(() {
                                      // TODO Handle task completion
                                    });
                                  },
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      schedule['tasks'].remove(subTask);
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
