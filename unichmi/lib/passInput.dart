import 'package:flutter/material.dart';

class PassInputWidget extends StatefulWidget {
  final void Function({required String data}) changeData;

  const PassInputWidget({super.key, required this.changeData});

  @override
  State<PassInputWidget> createState() => _PassInputWidgetState();
}

class _PassInputWidgetState extends State<PassInputWidget> {
  bool isShown = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none, labelText: 'Пароль'),
              onChanged: (e) => {widget.changeData(data: e)},
              obscureText: !isShown,
            ),
          ),
          IconButton(
            splashRadius: 0.1,
            onPressed: () {
              isShown = !isShown;
              setState(() {});
            },
            icon: Icon(isShown
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined),
          )
        ],
      ),
    );
  }
}
