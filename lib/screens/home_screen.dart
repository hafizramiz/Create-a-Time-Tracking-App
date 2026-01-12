import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:createatimetrackingapp/provider/time_entry_provider.dart';
import 'package:createatimetrackingapp/screens/add_time_entry_screen.dart';
import 'package:createatimetrackingapp/screens/project_management_screen.dart';
import 'package:createatimetrackingapp/screens/task_management_screen.dart';
import 'package:createatimetrackingapp/screens/statistics_screen.dart';
import 'package:createatimetrackingapp/models/project.dart';
import 'package:createatimetrackingapp/models/task.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Time Tracking',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: () => _showSortFilterSheet(context),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Color(0xFFF0C84B),
            indicatorWeight: 4,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'All Entries'),
              Tab(text: 'Grouped by Projects'),
            ],
          ),
        ),
        drawer: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 150,
                width: double.infinity,
                color: const Color(0xFF458B7D),
                alignment: Alignment.center,
                child: const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.folder, color: Colors.black),
                title: const Text('Projects'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectManagementScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment, color: Colors.black),
                title: const Text('Tasks'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskManagementScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart, color: Colors.black),
                title: const Text('Statistics'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StatisticsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildAllEntries(context), _buildGroupedEntries(context)],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
            );
          },
          child: const Icon(Icons.add, size: 36),
        ),
      ),
    );
  }

  void _showSortFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<TimeEntryProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sort by',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8,
                    children: ['Date', 'Duration', 'Project'].map((type) {
                      return ChoiceChip(
                        label: Text(type),
                        selected: provider.sortType == type,
                        onSelected: (selected) {
                          if (selected) provider.setSortType(type);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Filter by Project',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<String?>(
                    isExpanded: true,
                    value: provider.filterProjectId,
                    hint: const Text('All Projects'),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All Projects'),
                      ),
                      ...provider.projects.map(
                        (p) => DropdownMenuItem<String?>(
                          value: p.id,
                          child: Text(p.name),
                        ),
                      ),
                    ],
                    onChanged: (value) => provider.setFilterProjectId(value),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Widget _buildAllEntries(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        final entries = provider.filteredEntries;
        if (entries.isEmpty) {
          return _buildEmptyState();
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries[index];
            final project = provider.projects.firstWhere(
              (p) => p.id == entry.projectId,
              orElse: () =>
                  Project(id: '', name: 'Unknown Project', isDefault: false),
            );
            final task = provider.tasks.firstWhere(
              (t) => t.id == entry.taskId,
              orElse: () => Task(id: '', name: 'Unknown Task'),
            );

            return Card(
              color: Colors.white,
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${project.name} - ${task.name}',
                            style: const TextStyle(
                              color: Color(0xFF458B7D),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total Time: ${entry.totalTime.toStringAsFixed(0)} hours',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Date: ${_formatDate(entry.date)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Note: ${entry.notes}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFFD32F2F)),
                      onPressed: () => provider.deleteTimeEntry(entry.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGroupedEntries(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        final grouped = provider.groupedEntries;
        if (grouped.isEmpty) {
          return _buildEmptyState();
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children: grouped.entries.map((group) {
            return Card(
              color: Colors.white,
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.key,
                      style: const TextStyle(
                        color: Color(0xFF458B7D),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...group.value.map((entry) {
                      final taskName = provider.tasks
                          .firstWhere(
                            (t) => t.id == entry.taskId,
                            orElse: () => Task(id: '', name: 'Unknown Task'),
                          )
                          .name;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '- $taskName: ${entry.totalTime.toStringAsFixed(0)} hours (${_formatDate(entry.date)})',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 100, color: Colors.grey[400]),
          const SizedBox(height: 20),
          const Text(
            'No time entries yet!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap the + button to add your first entry.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
