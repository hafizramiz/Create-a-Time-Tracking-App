class Project {
  final String id;
  final String name;
  final bool isDefault;

  Project({required this.id, required this.name, this.isDefault = false});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'isDefault': isDefault,
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'],
    isDefault: json['isDefault'] ?? false,
  );
}
