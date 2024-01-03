import 'package:calendar_scheduler_ex01/model/schedule_model.dart';
import 'package:calendar_scheduler_ex01/repository/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repository;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({
    required this.repository,
  }) : super() {
    getSchedules(date: selectedDate);
  }

  void getSchedules({
    required DateTime date,
  }) async {
    final resp = await repository.getSchedules(date: date);
    cache.update(date, (value) => resp, ifAbsent: () => resp);
    notifyListeners();
  }

  void createSchedule({
    required ScheduleModel schedule,
  }) async {
    final targetDate = schedule.date;
    const uuid = Uuid();
    final tempId = uuid.v4(); // 유일한 id생성
    final newSchedule = schedule.copyWith(
      // cache.update에 넣을 임시 스캐줄
      id: tempId,
    );
    //긍정적 응답구간. 서버에서 응답을 받기 전에 캐시를 먼저 업데이트한다.
    print('cache update 시작');
    cache.update(
      targetDate,
      (value) => [
        ...value,
        newSchedule,
      ]..sort((a, b) => a.startTime.compareTo(b.startTime)),
      ifAbsent: () => [newSchedule],
    );
    print('cache 업데이트 다음과 같다.=> $cache');
    notifyListeners(); // 캐시 업데이ㅡ 반영하기

    try {
      // 진짜 데이터를 받아오고, 업데이트 하는 과정, 에러가 발생할 경우에 캐시롤백
      final savedSchedule = await repository.createSchedule(schedule: schedule);
      cache.update(
        targetDate,
        (value) => value
            .map((e) => e.id == tempId ? e.copyWith(id: savedSchedule) : e)
            .toList(),
      );
    } catch (e) {
      // 서버로 저장하는 것 실패하고, 또한 새로운 데이터로 캐시업데이트 실패
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(), //filter이다.
      ); // 캐시를 원래로 되돌림(롤백)
    }
    notifyListeners(); // 캐시 변화된 것 화면에 반영됨
  }

  void deleteSchedule({
    required DateTime date,
    required String id,
  }) async {
    final targetSchedule = cache[date]!.firstWhere(
      (e) => e.id == id,
    ); // 삭제할 일정 기억(schedule) , 나중에 다시 사용할 수 있게

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    ); // 삭제전에 캐시를 먼저 업데이트
    notifyListeners(); // 캐시업데이트 반영하기. 긍정적응답

    try {
      await repository.deleteSchedule(id: id);
    } catch (e) {
      //삭제 실패시, 캐시를 다시 롤백 -> notify 하면 화면에 반영됨
      cache.update(
        date,
        (value) => [...value, targetSchedule] // 삭제한 것과 동일한 스캐줄 다시 넣어줌
          ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      );
    }
    notifyListeners();
  }

  void changeSelectedDate({
    required DateTime date,
  }) {
    selectedDate = date;
    notifyListeners();
  }
}
