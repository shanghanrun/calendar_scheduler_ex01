import 'package:calendar_scheduler_ex01/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final isAboutTime;
  const CustomTextField(
      {required this.label, required this.isAboutTime, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, color: PRIMARY),
        ),
        Expanded(
          flex: isAboutTime ? 0 : 1,
          child: TextFormField(
            maxLines: isAboutTime ? 1 : null,
            keyboardType:
                isAboutTime ? TextInputType.number : TextInputType.multiline,
            cursorColor: Colors.grey,
            expands: !isAboutTime,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[300],
              suffixText: isAboutTime ? '시' : null,
            ),
            inputFormatters:
                isAboutTime ? [FilteringTextInputFormatter.digitsOnly] : [],
          ),
        ),
      ],
    );
  }
}
