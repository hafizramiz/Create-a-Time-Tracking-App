import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:createatimetrackingapp/provider/time_entry_provider.dart';
import '../models/task.dart';

class TaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tasks'),
        backgroundColor: const Color(0xFF4B1D6E),
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          if (provider.tasks.isEmpty) {
            return const Center(child: Text('No tasks yet. Add one!'));
          }
          return ListView.builder(
            itemCount: provider.tasks.length,
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return ListTile(
                title: Text(task.name, style: const TextStyle(fontSize: 18)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFFD32F2F)),
                  onPressed: () => provider.deleteTask(task.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Task', style: TextStyle(fontSize: 24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Task Name',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Task 1',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Provider.of<TimeEntryProvider>(context, listen: false).addTask(
                  Task(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: controller.text,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
