import 'package:createatimetrackingapp/provider/time_entry_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:createatimetrackingapp/models/time_entry.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId;
  String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
        backgroundColor: const Color(0xFF458B7D),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Consumer<TimeEntryProvider>(
            builder: (context, provider, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Project',
                    style: TextStyle(color: Colors.black54),
                  ),
                  DropdownButtonFormField<String>(
                    value: projectId,
                    onChanged: (String? newValue) {
                      setState(() {
                        projectId = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a project' : null,
                    decoration: const InputDecoration(border: InputBorder.none),
                    items: provider.projects.map<DropdownMenuItem<String>>((
                      project,
                    ) {
                      return DropdownMenuItem<String>(
                        value: project.id,
                        child: Text(
                          project.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text('Task', style: TextStyle(color: Colors.black54)),
                  DropdownButtonFormField<String>(
                    value: taskId,
                    onChanged: (String? newValue) {
                      setState(() {
                        taskId = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a task' : null,
                    decoration: const InputDecoration(border: InputBorder.none),
                    items: provider.tasks.map<DropdownMenuItem<String>>((task) {
                      return DropdownMenuItem<String>(
                        value: task.id,
                        child: Text(
                          task.name,
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date: ${date.toString().substring(0, 10)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != date) {
                        setState(() {
                          date = picked;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Select Date'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Total Time (in hours)',
                    style: TextStyle(color: Colors.black54),
                  ),
                  TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(border: InputBorder.none),
                    style: const TextStyle(fontSize: 18),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Please enter total time';
                      if (double.tryParse(value) == null)
                        return 'Please enter a valid number';
                      return null;
                    },
                    onSaved: (value) => totalTime = double.parse(value!),
                  ),
                  const SizedBox(height: 16),
                  const Text('Note', style: TextStyle(color: Colors.black54)),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter notes here...',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                    style: const TextStyle(fontSize: 18),
                    onSaved: (value) => notes = value ?? '',
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          provider.addTimeEntry(
                            TimeEntry(
                              id: DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                              projectId: projectId!,
                              taskId: taskId!,
                              totalTime: totalTime,
                              date: date,
                              notes: notes,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save Time Entry',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
