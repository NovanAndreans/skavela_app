// lib/Models/Activity.dart

class Activity {
  final int? id;
  final String action;
  final String description;
  final String createdAt;

  Activity({
    this.id,
    required this.action,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "action": action,
      "description": description,
      "created_at": createdAt,
    };
  }

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map["id"],
      action: map["action"],
      description: map["description"],
      createdAt: map["created_at"],
    );
  }
}
