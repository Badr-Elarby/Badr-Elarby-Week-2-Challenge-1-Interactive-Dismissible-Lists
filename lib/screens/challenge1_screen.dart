import 'package:flutter/material.dart';

class Task {
  String name;
  bool completed;

  Task({required this.name, this.completed = false});
}

class Challenge1Screen extends StatefulWidget {
  const Challenge1Screen({super.key});

  @override
  State<Challenge1Screen> createState() => _Challenge1ScreenState();
}

class _Challenge1ScreenState extends State<Challenge1Screen> {
  List<Task> tasks = [
    Task(name: 'Task 1 Task 1 Task 1 Task 1 Task 1 Task 1 Task 1 '),
    Task(name: 'Task 2 Task 2 Task 2 Task 2 Task 2 Task 2 Task 2  '),
    Task(name: 'Task 3 Task 3 Task 3 Task 3 Task 3 Task 3 Task 3 '),
    Task(name: 'Task 4 Task 4 Task 4 Task 4 Task 4 Task 4 Task 4'),
    Task(name: 'Task 5 Task 5 Task 5 Task 5 Task 5 Task 5 Task 5 '),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge 1')),
      body: ReorderableListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Dismissible(
            key: ValueKey(task.name),
            direction: DismissDirection.endToStart,
            confirmDismiss: (direction) async {
              // ignore: use_build_context_synchronously
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Delete'),
                  content: const Text(
                    'Are you sure you want to delete this task?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('No'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              );
              if (result == true) {
                final removedTask = tasks.removeAt(index);
                setState(() {});
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Task deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        setState(() {
                          tasks.insert(index, removedTask);
                        });
                      },
                    ),
                  ),
                );
              }
              return result ?? false;
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: Card(
              key: ValueKey(task.name),
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    setState(() {
                      task.completed = !task.completed;
                    });
                  },
                  child: Icon(
                    task.completed
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                  ),
                ),
                title: Text(
                  task.name,
                  style: TextStyle(
                    decoration: task.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
              ),
            ),
          );
        },
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex--;
            final item = tasks.removeAt(oldIndex);
            tasks.insert(newIndex, item);
          });
        },
      ),
    );
  }
}
