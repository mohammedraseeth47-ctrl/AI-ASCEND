class TripStop {
  final String id;
  final int sequenceNumber;
  final String stopName;
  final String scheduledTime;
  final String? scheduledArrival;
  final String? scheduledDeparture;
  final String? actualTime;
  final bool isCompleted;
  final bool isCurrent;
  final bool isTerminal;
  final String? landmarks;

  const TripStop({
    required this.id,
    required this.sequenceNumber,
    required this.stopName,
    required this.scheduledTime,
    this.scheduledArrival,
    this.scheduledDeparture,
    this.actualTime,
    this.isCompleted = false,
    this.isCurrent = false,
    this.isTerminal = false,
    this.landmarks,
  });

  factory TripStop.fromFirestore(Map<String, dynamic> data) {
    return TripStop(
      id: data['id'] as String? ?? '',
      sequenceNumber: (data['sequence'] as num?)?.toInt() ?? 0,
      stopName: data['name'] as String? ?? '',
      scheduledTime: data['scheduledTime'] as String? ?? '',
      scheduledArrival: data['scheduledArrival'] as String?,
      scheduledDeparture: data['scheduledDeparture'] as String?,
      actualTime: data['actualTime'] as String?,
      isCompleted: data['isCompleted'] as bool? ?? false,
      isCurrent: data['isCurrent'] as bool? ?? false,
      isTerminal: data['isTerminal'] as bool? ?? false,
      landmarks: data['landmarks'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'sequence': sequenceNumber,
      'name': stopName,
      'scheduledTime': scheduledTime,
      if (scheduledArrival != null) 'scheduledArrival': scheduledArrival,
      if (scheduledDeparture != null) 'scheduledDeparture': scheduledDeparture,
      if (actualTime != null) 'actualTime': actualTime,
      'isCompleted': isCompleted,
      'isCurrent': isCurrent,
      'isTerminal': isTerminal,
      if (landmarks != null) 'landmarks': landmarks,
    };
  }

  TripStop copyWith({
    String? id,
    int? sequenceNumber,
    String? stopName,
    String? scheduledTime,
    String? scheduledArrival,
    String? scheduledDeparture,
    String? actualTime,
    bool? isCompleted,
    bool? isCurrent,
    bool? isTerminal,
    String? landmarks,
  }) {
    return TripStop(
      id: id ?? this.id,
      sequenceNumber: sequenceNumber ?? this.sequenceNumber,
      stopName: stopName ?? this.stopName,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      scheduledArrival: scheduledArrival ?? this.scheduledArrival,
      scheduledDeparture: scheduledDeparture ?? this.scheduledDeparture,
      actualTime: actualTime ?? this.actualTime,
      isCompleted: isCompleted ?? this.isCompleted,
      isCurrent: isCurrent ?? this.isCurrent,
      isTerminal: isTerminal ?? this.isTerminal,
      landmarks: landmarks ?? this.landmarks,
    );
  }
}
