import 'package:calendar_scheduler_ex01/component/main_calendar.dart';
import 'package:calendar_scheduler_ex01/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler_ex01/component/schedule_card.dart';
import 'package:calendar_scheduler_ex01/component/today_banner.dart';
import 'package:calendar_scheduler_ex01/const/colors.dart';
import 'package:calendar_scheduler_ex01/database/drift_database.dart';
import 'package:calendar_scheduler_ex01/provider/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate; // 변경된 값을 받아옴
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('스케줄 관리')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY,
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            isScrollControlled: true,
            builder: (_) => ScheduleBottomSheet(selectedDate: selectedDate),
          );
        },
      ),
      body: Column(
        children: [
          MainCalendar(
            selectedDate: selectedDate,
            onDaySelected: (selectedDate, focusedDate) =>
                onDaySelected(selectedDate, focusedDate, context),
          ),
          const SizedBox(height: 8),
          TodayBanner(
            selectedDate: selectedDate,
            count: schedules.length,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, i) {
                  final schedule = schedules[i];
                  return Dismissible(
                    key: ObjectKey(schedule.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (DismissDirection direction) {
                      provider.deleteSchedule(
                          date: selectedDate, id: schedule.id);
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 8, right: 8),
                      child: ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);
  }
}
