import 'package:calendar_scheduler_ex01/component/custom_textfield.dart';
import 'package:calendar_scheduler_ex01/const/colors.dart';
import 'package:flutter/material.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; //키보드 높이
    return SafeArea(
      child: Container(
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            padding:
                EdgeInsets.only(left: 8, right: 8, top: 8, bottom: bottomInset),
            child: Column(
              children: [
                const Row(
                  children: [
                    Expanded(
                        child:
                            CustomTextField(label: '시작 시간', isAboutTime: true)),
                    SizedBox(width: 16),
                    Expanded(
                        child:
                            CustomTextField(label: '종료 시간', isAboutTime: true)),
                  ],
                ),
                const SizedBox(height: 8),
                const Expanded(
                    child: CustomTextField(label: '내용', isAboutTime: false)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSave,
                    style: ElevatedButton.styleFrom(backgroundColor: PRIMARY),
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void onSave() {}
}
