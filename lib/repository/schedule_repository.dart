import 'dart:async';
import 'dart:io';

import 'package:calendar_scheduler_ex01/model/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final _dio = Dio();
  final _targetUrl =
      'http://${Platform.isAndroid ? '10.0.2.2' : 'localhost'}:3000/schedule';

  Future<List<ScheduleModel>> getSchedules({
    required DateTime date,
  }) async {
    final resp = await _dio.get(
      _targetUrl,
      queryParameters: {
        'date':
            '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}'
      },
    );

    return resp.data
        .map<ScheduleModel>(
          (x) => ScheduleModel.fromJson(
            json: x,
          ),
        )
        .toList();
  }

  Future<String> createSchedule({
    required ScheduleModel schedule,
  }) async {
    print('리파지토리 일정 생성시작');
    try {
      final json = schedule.toJson();
      final resp = await _dio.post(_targetUrl, data: json);
      return resp.data?['id'];
    } catch (e) {
      print('다음과 같은 에러가 발생했습니다. $e');
    }
    // final json = schedule.toJson();
    // final resp = await _dio.post(_targetUrl, data: json);
    print('리파지토리 일정생성 완료');
    return '';
  }

  Future<String> deleteSchedule({
    required String id,
  }) async {
    final resp = await _dio.delete(_targetUrl, data: {'id': id});
    return resp.data?['id'];
  }
}
