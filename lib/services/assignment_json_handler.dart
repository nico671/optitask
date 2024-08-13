class WholeJSONModel {
  //TODO:Figure out wtf happened here and just make it better tbh

  final String assignmentName;
  final String startDateTime;
  final String endDateTime;

  final String assignmentType;

  final String courseName;

  final String time;
  factory WholeJSONModel.fromJson(Map<String, dynamic> jsonInput, int index) {
    return WholeJSONModel(
        startDateTime: jsonInput.values.toList()[index]['start_datetime'],
        endDateTime: jsonInput.values.toList()[index]['end_datetime'],
        time: jsonInput.values.toList()[index]['to_do']['time'],
        assignmentType: jsonInput.values.toList()[index]['assignment_type'],
        courseName: jsonInput.values.toList()[index]['course_name'],
        assignmentName: jsonInput.keys.toList()[index].toString());
  }
  const WholeJSONModel({
    required this.startDateTime,
    required this.endDateTime,
    required this.time,
    required this.assignmentType,
    required this.courseName,
    required this.assignmentName,
  });
}
