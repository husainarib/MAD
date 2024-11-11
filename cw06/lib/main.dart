import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

// // TESTING FIREBASE CONNECTION
//   Future<void> testWrite() async {
//     try {
//       await FirebaseFirestore.instance.collection('testCollection').add({
//         'testField': 'testValue',
//       });
//       print('Write successful');
//     } catch (e) {
//       print('Error writing to Firestore: $e');
//     }
//   }

  Future<User?> _sign(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      // ERROR CHECKING
      print("Error signing in: $e");
      return null;
    }
  }

  Future<User?> _register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      // ERROR CHECKING
      print("Error registering: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _addTask(String taskName) async {
    if (taskName.isNotEmpty) {
      await _tasksCollection.add({
        'name': taskName,
        'isCompleted': false,
      });
      _taskController.clear();
    }
  }

  Future<void> _toggleTaskCompletion(DocumentSnapshot taskDoc) async {
    bool currentStatus = taskDoc['isCompleted'];
    await _tasksCollection.doc(taskDoc.id).update({
      'isCompleted': !currentStatus,
    });
  }

  Future<void> _deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  Future<void> _addSubTask(
      String taskId, String subTaskName, String timeFrame) async {
    if (subTaskName.isNotEmpty && timeFrame.isNotEmpty) {
      await _tasksCollection.doc(taskId).collection('subTasks').add(
          {'name': subTaskName, 'timeFrame': timeFrame, 'isCompleted': false});
    }
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
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // // TESTING FIREBASE CONNECTION
                // ElevatedButton(
                //   onPressed: testWrite,
                //   child: const Text('Test Firestore Write'),
                // ),
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    decoration: const InputDecoration(
                      labelText: 'Enter task name',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addTask(_taskController.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _tasksCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot taskDoc =
                          snapshot.data!.docs[index];
                      return TaskTile(
                        taskDoc: taskDoc,
                        onToggleComplete: () => _toggleTaskCompletion(taskDoc),
                        onDelete: () => _deleteTask(taskDoc.id),
                        onAddSubTask: (subTaskName, timeFrame) =>
                            _addSubTask(taskDoc.id, subTaskName, timeFrame),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TaskTile extends StatefulWidget {
  final DocumentSnapshot taskDoc;
  final VoidCallback onToggleComplete;
  final VoidCallback onDelete;
  final Function(String subTaskName, String timeFrame) onAddSubTask;

  const TaskTile({
    Key? key,
    required this.taskDoc,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onAddSubTask,
  }) : super(key: key);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final TextEditingController _subTaskNameController = TextEditingController();
  final TextEditingController _timeFrameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ExpansionTile(
        title: Row(
          children: [
            Checkbox(
              value: widget.taskDoc['isCompleted'],
              onChanged: (value) => widget.onToggleComplete(),
            ),
            Text(
              widget.taskDoc['name'],
              style: TextStyle(
                decoration: widget.taskDoc['isCompleted']
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
          ],
        ),
        children: [
          StreamBuilder(
            stream: widget.taskDoc.reference.collection('subTasks').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.docs.map((subTaskDoc) {
                    return ListTile(
                      title: Text(
                          "${subTaskDoc['timeFrame']}: ${subTaskDoc['name']}"),
                      leading: Checkbox(
                        value: subTaskDoc['isCompleted'],
                        onChanged: (value) {
                          subTaskDoc.reference
                              .update({'isCompleted': value ?? false});
                        },
                      ),
                    );
                  }).toList(),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _subTaskNameController,
                    decoration: const InputDecoration(
                      labelText: 'Sub-task name',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _timeFrameController,
                    decoration: const InputDecoration(
                      labelText: 'Time frame',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    widget.onAddSubTask(
                      _subTaskNameController.text,
                      _timeFrameController.text,
                    );
                    _subTaskNameController.clear();
                    _timeFrameController.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
