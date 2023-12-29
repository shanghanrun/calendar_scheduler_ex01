import 'package:calendar_scheduler_ex01/component/main_calendar.dart';
import 'package:calendar_scheduler_ex01/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler_ex01/component/schedule_card.dart';
import 'package:calendar_scheduler_ex01/const/colors.dart';
import 'package:flutter/material.dart';

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
            builder: (_) => const ScheduleBottomSheet(),
          );
        },
      ),
      body: Column(
        children: [
          MainCalendar(
            selectedDate: selectedDate,
            onDaySelected: onDaySelected,
          ),
          const ScheduleCard(startTime: 12, endTime: 14, content: '플러터 공부')
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
