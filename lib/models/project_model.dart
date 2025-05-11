class Project {
  final String id;
  final String title;
  final String description;
  final String ownerId;
  final Map<String, String> members; // {uid: role} ex: {'abc123': 'invité'}

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.ownerId,
    required this.members,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'ownerId': ownerId,
      'members': members,
    };
  }

  factory Project.fromMap(String id, Map<String, dynamic> data) {
    return Project(
      id: id,
      title: data['title'],
      description: data['description'],
      ownerId: data['ownerId'],
      members: Map<String, String>.from(data['members'] ?? {}),
    );
  }
}
