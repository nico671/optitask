import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:optitask/models/assignment.dart';
import 'package:intl/intl.dart';
import '../services/api.dart';
import '../services/assignment_json_handler.dart';

class AssignmentsListProvider extends ChangeNotifier {
  Map<int, List<Assignment>> assignmentMap = {};

  // returns number of completed assignments
  int completedCount() {
    int completedCount = 0;
    if (assignmentMap[selectedDate.day] == null) {
      return 0;
    }
    List<Assignment> assignmentList = assignmentMap[selectedDate.day]!;
    for (Assignment a in assignmentList) {
      if (a.completed == true) {
        completedCount++;
      }
    }
    return completedCount;
  }

  double percentageCompleted() {
    int completedCount = 0;
    if (assignmentMap[selectedDate.day] == null) {
      return 0;
    }
    List<Assignment> assignmentList = assignmentMap[selectedDate.day]!;
    if (assignmentList.isEmpty) {
      return 0;
    }
    for (Assignment a in assignmentList) {
      if (a.completed == true) {
        completedCount++;
      }
    }
    return (completedCount / assignmentList.length) * 100;
  }

  void calculate(
      DateTime date, BuildContext context, DateTime wantedDate) async {
    List<Assignment> newAssignmentList = [];
    Api api = Api();
    DatabaseReference ref = FirebaseDatabase.instance.ref('users');

    var data = await ref.child(FirebaseAuth.instance.currentUser!.uid).get();

    dynamic blah = data.value;
    log(blah.toString());
    blah['today'] = DateFormat('yyyy-MM-dd').format(wantedDate);
    blah['user_data']['temp_data'] = {};
    log('calculate$blah');
    var realData = await api.getToDo(blah);
    log('realData$realData');
    if (realData.runtimeType == int) {
      if (realData == 503) {
        if (context.mounted) {}
      }
      if (realData == 404) {
        if (context.mounted) {}
      }

      return;
    }
    int index = realData.data.indexOf('{');
    String tempString = realData.data.substring(index, realData.data.length);
    final temperer = jsonDecode(tempString);
    Map<String, dynamic> fakeData =
        temperer['user_data']['temp_data'] as Map<String, dynamic>;

    // var fakeData = accfakeData;
    for (int i = 0; i < fakeData.values.length; i++) {
      log(fakeData.toString());
      Assignment assignment = Assignment(
        completed: false,
        assignmentName: WholeJSONModel.fromJson(fakeData, i).assignmentName,
        time: WholeJSONModel.fromJson(fakeData, i).time,
        startDateTime: WholeJSONModel.fromJson(fakeData, i).startDateTime,
        endDateTime: WholeJSONModel.fromJson(fakeData, i).endDateTime,
        assignmentType: WholeJSONModel.fromJson(fakeData, i).assignmentType,
        courseName: WholeJSONModel.fromJson(fakeData, i).courseName,
      );
      log('$assignment $i');
      newAssignmentList.add(assignment);
    }
    log('assignmentlist: $newAssignmentList');
    if (assignmentMap[date.day] != null) {
      assignmentList = assignmentMap[date.day]!;
    } else {
      assignmentMap[date.day] = newAssignmentList;
      assignmentList = assignmentMap[date.day]!;
    }

    notifyListeners();
  }

  List<Assignment> assignmentList = [];

  DateTime selectedDate = DateTime.now();

  final DateFormat formatter = DateFormat('MMMM yyyy');

  void setSelectedDate(DateTime newDate) {
    selectedDate = newDate;
    if (assignmentMap[selectedDate.day] != null) {
      assignmentList = assignmentMap[selectedDate.day]!;
    } else {
      assignmentList = [];
    }

    notifyListeners();
  }

  void toggleCompleted(int index) {
    if (assignmentMap[selectedDate.day] == null) {
      return;
    }
    List<Assignment> assignmentList = assignmentMap[selectedDate.day]!;
    if (assignmentList.elementAt(index).completed == true) {
      assignmentList.elementAt(index).completed = false;
      Assignment temp = assignmentList[index];
      assignmentList.removeAt(index);
      assignmentList.insert((assignmentList.length - completedCount()), temp);
    } else {
      assignmentList.elementAt(index).completed = true;
      Assignment temp = assignmentList[index];
      assignmentList.removeAt(index);
      assignmentList.add(temp);
    }
    notifyListeners();
  }
}
