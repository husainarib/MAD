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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Enter task',
                      filled: true,
                      fillColor: Color.fromARGB(255, 215, 229, 235),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      addTask(controller.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskItem(
                  task: tasks[index],
                  toggle: () => checkTask(index),
                  delete: () => deleteTask(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// displays a task with a checkbox to toggle its status and a delete button
class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback toggle;
  final VoidCallback delete;

  const TaskItem({
    super.key,
    required this.task,
    required this.toggle,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: task.status,
        onChanged: (value) => toggle(),
      ),
      title: Text(
        task.name,
        style: TextStyle(
          decoration: task.status ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.red,
        onPressed: delete,
      ),
    );
  }
}
