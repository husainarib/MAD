import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

class Task {
  String id;
  String name;
  bool isComplete;
  Map<String, List<Map<String, dynamic>>> nestedTasks;

  Task({
    required this.id,
    required this.name,
    this.isComplete = false,
    required this.nestedTasks,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isComplete': isComplete,
      'nestedTasks': nestedTasks,
    };
  }

  static Task fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      name: map['name'],
      isComplete: map['isComplete'],
      nestedTasks: Map<String, List<Map<String, dynamic>>>.from(map['nestedTasks']),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _subTaskController = TextEditingController();

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      final task = Task(
        id: FirebaseFirestore.instance.collection('tasks').doc().id,
        name: _taskController.text,
        nestedTasks: {},
      );
      FirebaseFirestore.instance.collection('tasks').doc(task.id).set(task.toMap());
      _taskController.clear();
    }
  }

  void _toggleTaskCompletion(Task task) {
    FirebaseFirestore.instance.collection('tasks').doc(task.id).update({
      'isComplete': !task.isComplete,
    });
  }

  void _deleteTask(String taskId) {
    FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
  }

  void _addSubTask(Task task, String day, String time) {
    setState(() {
      if (!task.nestedTasks.containsKey(day)) {
        task.nestedTasks[day] = [];
      }
      task.nestedTasks[day]!.add({
        'time': time,
        'tasks': [_subTaskController.text],
      });
      FirebaseFirestore.instance
          .collection('tasks')
          .doc(task.id)
          .update({'nestedTasks': task.nestedTasks});
      _subTaskController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      labelText: 'Enter task name',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final tasks = snapshot.data!.docs.map((doc) {
                  return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
                }).toList();

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return ExpansionTile(
                      title: Row(
                        children: [
                          Checkbox(
                            value: task.isComplete,
                            onChanged: (value) => _toggleTaskCompletion(task),
                          ),
                          Expanded(child: Text(task.name)),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteTask(task.id),
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _subTaskController,
                                      decoration: InputDecoration(
                                        labelText: 'Enter sub-task name',
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      _showAddSubTaskDialog(task);
                                    },
                                  ),
                                ],
                              ),
                              if (task.nestedTasks.isNotEmpty)
                                for (var day in task.nestedTasks.keys)
                                  ExpansionTile(
                                    title: Text(day,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    children: [
                                      for (var timeSlotIndex = 0;
                                          timeSlotIndex <
                                              task.nestedTasks[day]!.length;
                                          timeSlotIndex++)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  task.nestedTasks[day]![
                                                      timeSlotIndex]['time'],
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600)),
                                              ...task
                                                  .nestedTasks[day]![timeSlotIndex]
                                                      ['tasks']
                                                  .map<Widget>((subTask) {
                                                return ListTile(
                                                  title: Text(subTask),
                                                  leading: Checkbox(
                                                    value: false,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        // Mark sub-task as complete
                                                      });
                                                    },
                                                  ),
                                                  trailing: IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      _deleteSubTask(task, day,
                                                          timeSlotIndex, subTask);
                                                    },
                                                  ),
                                                );
                                              }).toList(),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddSubTaskDialog(Task task) {
    String selectedDay = 'Monday';
    String selectedTime = '9 am - 10 am';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Sub-Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _subTaskController,
              decoration: InputDecoration(labelText: 'Sub-task name'),
            ),
            DropdownButton<String>(
              value: selectedDay,
              onChanged: (newDay) {
                setState(() {
                  selectedDay = newDay!;
                });
              },
              items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
                  .map((day) => DropdownMenuItem(
                        value: day,
                        child: Text(day),
                      ))
                  .toList(),
            ),
            DropdownButton<String>(
              value: selectedTime,
              onChanged: (newTime) {
                setState(() {
                  selectedTime = newTime!;
                });
              },
              items: [
                '9 am - 10 am',
                '12 pm - 2 pm',
                '3 pm - 4 pm',
              ]
                  .map((time) => DropdownMenuItem(
                        value: time,
                        child: Text(time),
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addSubTask(task, selectedDay, selectedTime);
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteSubTask(Task task, String day, int timeIndex, String subTask) {
    setState(() {
      task.nestedTasks[day]![timeIndex]['tasks'].remove(subTask);
      if (task.nestedTasks[day]![timeIndex]['tasks'].isEmpty) {
        task.nestedTasks[day]!.removeAt(timeIndex);
      }
      if (task.nestedTasks[day]!.isEmpty) {
        task.nestedTasks.remove(day);
      }
      FirebaseFirestore.instance
          .collection('tasks')
          .doc(task.id)
          .update({'nestedTasks': task.nestedTasks});
    });
  }
}
