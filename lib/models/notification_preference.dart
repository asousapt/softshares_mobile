class NotificationPreference {
  final int id;
  final String type;
  final bool enabled;

  NotificationPreference({
    required this.id,
    required this.type,
    required this.enabled,
  });

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id'],
      type: json['type'],
      enabled: json['enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'enabled': enabled,
    };
  }
}
