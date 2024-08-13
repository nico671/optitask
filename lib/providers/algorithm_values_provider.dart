import 'dart:developer';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AlgorithmValuesProvider extends ChangeNotifier {
  bool urlExplained = false;
  final DateFormat currentDayFormatter = DateFormat("y-M-d");
  // TODO: needs to be 24hr time
  final DateFormat timesFormatter = DateFormat("HH:mm:ss");

//MARK: - UI
  Map<String, dynamic> userJSON = {
    "base_target": "/api/v1/",
    "base_url": "",
    "headers": {"Authorization": "Bearer "},
    "laziness": 5,
    "today": "",
    "user_data": {
      "user_constants": {
        "pre_scheduled_time": {
          "activities": {},
          "base_unscheduled_times": {},
          "minimum_free_time": "00:00:00",
          "weekday_required_sleep": "00:00:00",
          "weekend_required_sleep": "00:00:00",
          "school_college_duration": "00:00:00",
          "work_time_before_school": "00:00:00",
        }
      },
      "work_constants_preferences": {
        "productivity_levels": {
          "friday": 0.7,
          "monday": 0.8,
          "saturday": 0.6,
          "sunday": 0.5,
          "thursday": 0.9,
          "tuesday": 0.7,
          "wednesday": 0.7
        },
        "study_preferences": {
          "max_assessment_study_time": "00:00:00",
          "max_homework_study_time": "00:00:00",
          "most_productive_time_of_day": "00:00:00",
        },
        "weights": {
          "fatigue_weights": [40.0, 40.0, 20.0],
          "time_weights": [40.0, 50.0, 10.0],
          "value_weights": [70.0, 20.0, 10.0],
        },
        "courses": {},
      }
    }
  };

  void updateToken(String token) {
    userJSON["headers"]['Authorization'] = "Bearer $token";
    notifyListeners();
  }

  void updateURL(String url) {
    userJSON["base_url"] = url;
    notifyListeners();
  }

  void setRequiredSleep(
      Duration weekdayRequiredSleep, Duration weekendRequiredSleep) {
    String weekdayRequiredSleepString = formDurat(weekdayRequiredSleep);
    String weekendRequiredSleepString = formDurat(weekendRequiredSleep);
    userJSON["user_data"]["user_constants"]["pre_scheduled_time"]
        ["weekday_required_sleep"] = weekdayRequiredSleepString;
    userJSON["user_data"]["user_constants"]["pre_scheduled_time"]
        ["weekend_required_sleep"] = weekendRequiredSleepString;
    notifyListeners();
  }

  void setCoursesData(Map<String, dynamic> courses) {
    userJSON["user_data"]["work_constants_preferences"]["courses"] = courses;
    notifyListeners();
  }

  void updateFirebase(dynamic userJSON) async {
    if (userJSON == {}) {
      return;
    }
    log("disposing: $userJSON");

    DatabaseReference exitRef = FirebaseDatabase.instance
        .ref('users/${FirebaseAuth.instance.currentUser!.uid}');
    exitRef.set(userJSON);
    log('updating firebase: $userJSON');
    notifyListeners();
  }
}

String formDurat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
}
