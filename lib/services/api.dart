// create a dart class to connect to an api using the dio library

import 'dart:developer';

import 'package:dio/dio.dart';

class Api {
  static const String baseUrl = 'https://opti-task.onrender.com';
  static const String gradeBook = '/getGradebook';
  static const String toDo = '/getToDo';
  static const String initialData = '/getInitialData';
  static const String unscheduledTimes = '/getUnscheduledTimes';
  static const String baseURL = '/getBaseURL';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
    ),
  );

  Future<dynamic> getGradebook(dynamic data) async {
    try {
      return await dio.post(gradeBook, data: data);
    } on DioError catch (e) {
      log(e.response!.statusCode.toString());
      return e.response!.statusCode;
    }
  }

  Future<dynamic> getBaseURL(String data) async {
    data = data.replaceAll(' ', '%20');

    try {
      return await dio.get(baseURL, queryParameters: {'query': data});
    } on DioError catch (e) {
      log(e.response!.statusCode.toString());
      return e.response!.statusCode;
    }
  }

  Future<dynamic> getToDo(dynamic data) async {
    try {
      return await dio.post(toDo, data: data);
    } on DioError catch (e) {
      log(e.response!.statusCode.toString());
      return e.response!.statusCode;
    }
  }

  Future<dynamic> getInitialData(dynamic data) async {
    try {
      return await dio.post(initialData, data: data);
    } on DioError catch (e) {
      log(e.response!.statusCode.toString());
      return e.response!.statusCode;
    }
  }

  Future<dynamic> getUnscheduledTimes(dynamic data) async {
    try {
      return await dio.post(unscheduledTimes, data: data);
    } on DioError catch (e) {
      log(e.response!.statusCode.toString());
      return e.response!.statusCode;
    }
  }
}
