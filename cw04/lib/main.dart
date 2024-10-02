//Arib Husain #002-62-2009
import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

class Task {
  String name;
  bool status;

  Task({required this.name, this.status = false});
}

class TaskManagerApp extends StatelessWidget {
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

//main screen
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreen createState() => _TaskListScreen();
}

class _TaskListScreen extends State<TaskListScreen> {
  // list that stores all tasks
  List<Task> tasks = [];
  TextEditingController controller = TextEditingController();

// method for adding tasking
  void addTask(String taskName) {
    setState(() {
      tasks.add(Task(name: taskName));
      controller.clear();
    });
  }

//method for checkbox
  void checkTask(int index) {
    setState(() {
      tasks[index].status = !tasks[index].status;
    });
  }

//method for deleting task
  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }
}


