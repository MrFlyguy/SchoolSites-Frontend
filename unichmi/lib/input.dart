import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final void Function({required String data}) changeData;
  final String placeholder;

  const TextInputWidget(
      {super.key, required this.changeData, required this.placeholder});

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none, labelText: widget.placeholder),
        onChanged: (e) => {widget.changeData(data: e)},
      ),
    );
  }
}
