import 'package:calendar_scheduler_ex01/component/custom_textfield.dart';
import 'package:calendar_scheduler_ex01/const/colors.dart';
import 'package:calendar_scheduler_ex01/database/drift_database.dart';
import 'package:calendar_scheduler_ex01/model/schedule_model.dart';
import 'package:calendar_scheduler_ex01/provider/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:provider/provider.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  const ScheduleBottomSheet({required this.selectedDate, super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  int? startTime;
  int? endTime;
  String? content;
  final GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; //키보드 높이
    return Form(
      key: formKey,
      child: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height / 2 + bottomInset,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 8, right: 8, top: 8, bottom: bottomInset),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                        label: '시작 시간',
                        isAboutTime: true,
                        onSaved: (String? val) {
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      )),
                      const SizedBox(width: 16),
                      Expanded(
                          child: CustomTextField(
                        label: '종료 시간',
                        isAboutTime: true,
                        onSaved: (val) {
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                      child: CustomTextField(
                    label: '내용',
                    isAboutTime: false,
                    onSaved: (val) {
                      content = val;
                    },
                    validator: contentValidator,
                  )),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => onSave(context),
                      style: ElevatedButton.styleFrom(backgroundColor: PRIMARY),
                      child: const Text('저장'),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void onSave(BuildContext context) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      print(startTime);
      print(endTime);
      print(content);

      context.read<ScheduleProvider>().createSchedule(
              schedule: ScheduleModel(
            id: 'new_model', // 임시 id
            startTime: startTime!,
            endTime: endTime!,
            content: content!,
            date: widget.selectedDate,
          ));
      Navigator.of(context).pop(); // 현재페이지 닫기 = 뒤로가기
    }
  }

  String? timeValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요.';
    }
    int? number;
    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해 주세요.';
    }

    if (number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해 주세요';
    }
    return null;
  }

  String? contentValidator(String? val) {
    if (val == null || val.isEmpty) {
      return '값을 입력해 주세요';
    }
    return null;
  }
}
