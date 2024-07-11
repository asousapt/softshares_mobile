class NotificationPreference {
  int? id;
  final String type;
  final bool enabled;
  int? utilizadorId;

  NotificationPreference({
    this.id,
    required this.type,
    required this.enabled,
    this.utilizadorId,
  });

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id'],
      type: json['type'],
      enabled: json['enabled'] == 1 ? true : false,
      utilizadorId: json['utilizadorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'enabled': enabled ? 1 : 0,
      'utilizadorId': utilizadorId,
    };
  }
}
