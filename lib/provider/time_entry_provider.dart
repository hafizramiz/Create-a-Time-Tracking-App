import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  List<Project> _projects = [];
  List<Task> _tasks = [];
  List<TimeEntry> _entries = [];
  String _sortType = 'Date'; // 'Date', 'Duration', 'Project'
  String? _filterProjectId;

  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;
  List<TimeEntry> get entries => _entries;
  String get sortType => _sortType;
  String? get filterProjectId => _filterProjectId;

  TimeEntryProvider() {
    _loadData();
  }

  void _loadData() {
    final projectsJson = localStorage.getItem('projects');
    if (projectsJson != null) {
      _projects = (jsonDecode(projectsJson) as List)
          .map((item) => Project.fromJson(item))
          .toList();
    } else {
      // Default projects matching the design
      _projects = [
        Project(id: '1', name: 'Project Alpha'),
        Project(id: '2', name: 'Project Beta'),
        Project(id: '3', name: 'Project Gamma'),
      ];
      _saveProjects();
    }

    final tasksJson = localStorage.getItem('tasks');
    if (tasksJson != null) {
      _tasks = (jsonDecode(tasksJson) as List)
          .map((item) => Task.fromJson(item))
          .toList();
    } else {
      // Default tasks matching the design
      _tasks = [
        Task(id: '1', name: 'Task A'),
        Task(id: '2', name: 'Task B'),
        Task(id: '3', name: 'Task C'),
      ];
      _saveTasks();
    }

    final entriesJson = localStorage.getItem('timeEntries');
    if (entriesJson != null) {
      _entries = (jsonDecode(entriesJson) as List)
          .map((item) => TimeEntry.fromJson(item))
          .toList();
    }
    notifyListeners();
  }

  void _saveProjects() {
    localStorage.setItem(
      'projects',
      jsonEncode(_projects.map((p) => p.toJson()).toList()),
    );
  }

  void _saveTasks() {
    localStorage.setItem(
      'tasks',
      jsonEncode(_tasks.map((t) => t.toJson()).toList()),
    );
  }

  void _saveEntries() {
    localStorage.setItem(
      'timeEntries',
      jsonEncode(_entries.map((e) => e.toJson()).toList()),
    );
  }

  // Project management
  void addProject(Project project) {
    _projects.add(project);
    _saveProjects();
    notifyListeners();
  }

  void deleteProject(String id) {
    _projects.removeWhere((p) => p.id == id);
    _saveProjects();
    notifyListeners();
  }

  // Task management
  void addTask(Task task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks();
    notifyListeners();
  }

  // Time Entry management
  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveEntries();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntries();
    notifyListeners();
  }

  // Sorting and Filtering
  void setSortType(String type) {
    _sortType = type;
    notifyListeners();
  }

  void setFilterProjectId(String? projectId) {
    _filterProjectId = projectId;
    notifyListeners();
  }

  List<TimeEntry> get filteredEntries {
    List<TimeEntry> filtered = List.from(_entries);

    // Apply Filter
    if (_filterProjectId != null && _filterProjectId!.isNotEmpty) {
      filtered = filtered
          .where((e) => e.projectId == _filterProjectId)
          .toList();
    }

    // Apply Sort
    if (_sortType == 'Date') {
      filtered.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortType == 'Duration') {
      filtered.sort((a, b) => b.totalTime.compareTo(a.totalTime));
    } else if (_sortType == 'Project') {
      filtered.sort((a, b) {
        final pA = _projects
            .firstWhere(
              (p) => p.id == a.projectId,
              orElse: () => Project(id: '', name: '', isDefault: false),
            )
            .name;
        final pB = _projects
            .firstWhere(
              (p) => p.id == b.projectId,
              orElse: () => Project(id: '', name: '', isDefault: false),
            )
            .name;
        return pA.compareTo(pB);
      });
    }

    return filtered;
  }

  // Grouped entries filtered by project if filter is applied
  Map<String, List<TimeEntry>> get groupedEntries {
    Map<String, List<TimeEntry>> groups = {};
    final entriesToGroup = filteredEntries;
    for (var entry in entriesToGroup) {
      final projectName = _projects
          .firstWhere(
            (p) => p.id == entry.projectId,
            orElse: () =>
                Project(id: '', name: 'Unknown Project', isDefault: false),
          )
          .name;
      groups.putIfAbsent(projectName, () => []).add(entry);
    }
    return groups;
  }
}
