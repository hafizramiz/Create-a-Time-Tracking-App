class Task {
  final String id;
  final String name;

  Task({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(id: json['id'], name: json['name']);
}
