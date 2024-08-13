class Assignment {
  bool completed;
  final String startDateTime;
  final String endDateTime;

  final String assignmentType;

  final String courseName;

  final String? time;
  final String assignmentName;
  Assignment({
    required this.completed,
    required this.assignmentName,
    required this.time,
    required this.startDateTime,
    required this.endDateTime,
    required this.assignmentType,
    required this.courseName,
  });

  void setCompleted(bool newVal) {
    completed = newVal;
  }
}
