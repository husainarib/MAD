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

class Task {
  String name;
  bool isComplete;
  Map<String, List<Map<String, dynamic>>> nestedTasks;

  Task({
    required this.name,
    this.isComplete = false,
    required this.nestedTasks,
  });
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _subTaskController = TextEditingController();
  List<Task> _tasks = [];

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(Task(
          name: _taskController.text,
          nestedTasks: {},
        ));
      });
      _taskController.clear();
    }
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
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
      _subTaskController.clear();
    });
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
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ExpansionTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: task.isComplete,
                        onChanged: (value) {
                          setState(() {
                            task.isComplete = value!;
                          });
                        },
                      ),
                      Expanded(child: Text(task.name)),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(index),
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
                                                    // TODO Mark sub-task as complete
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
                '11 am - 12 pm',
                '12 pm - 1 pm',
                '1 pm - 2 pm',
                '2 pm - 3 pm',
                '3 pm - 4 pm',
                '4 pm - 5 pm',
                '5 pm - 6 pm',
                '6 pm - 7 pm',
                '7 pm - 8 pm',
                '8 pm - 9 pm',
                '9 pm - 10 pm',
                '10 pm - 11 pm',
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
}
