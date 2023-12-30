import 'package:calendar_scheduler_ex01/component/main_calendar.dart';
import 'package:calendar_scheduler_ex01/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler_ex01/component/schedule_card.dart';
import 'package:calendar_scheduler_ex01/component/today_banner.dart';
import 'package:calendar_scheduler_ex01/const/colors.dart';
import 'package:calendar_scheduler_ex01/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  @override
  Widget build(BuildContext context) {
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
            onDaySelected: onDaySelected,
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.length ?? 0,
                );
              }),
          const SizedBox(height: 8),
          Expanded(
            child: StreamBuilder<List<Schedule>>(
                stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(); // 빈 화면
                  }
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, i) {
                        final schedule = snapshot.data![i];
                        return Dismissible(
                          key: ObjectKey(schedule.id),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (DismissDirection direction) {
                            GetIt.I<LocalDatabase>()
                                .removeSchedule(schedule.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, left: 8, right: 8),
                            child: ScheduleCard(
                                startTime: schedule.startTime,
                                endTime: schedule.endTime,
                                content: schedule.content),
                          ),
                        );
                      });
                }),
          ),
        ],
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
