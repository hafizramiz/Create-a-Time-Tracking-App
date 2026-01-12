import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:createatimetrackingapp/provider/time_entry_provider.dart';
import '../models/project.dart';

class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Projects'),
        backgroundColor: const Color(0xFF4B1D6E),
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          if (provider.projects.isEmpty) {
            return const Center(child: Text('No projects yet. Add one!'));
          }
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return ListTile(
                title: Text(project.name, style: const TextStyle(fontSize: 18)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Color(0xFFD32F2F)),
                  onPressed: () => provider.deleteProject(project.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProjectDialog(context);
        },
        child: const Icon(Icons.add, size: 36),
      ),
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Add Project', style: TextStyle(fontSize: 24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Project Name',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Project 123',
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
                Provider.of<TimeEntryProvider>(
                  context,
                  listen: false,
                ).addProject(
                  Project(
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
