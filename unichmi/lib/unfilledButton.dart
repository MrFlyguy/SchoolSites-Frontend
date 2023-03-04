import 'package:flutter/material.dart';

class UnfilledButton extends StatefulWidget {
  final String type;
  final void Function() onPress;
  const UnfilledButton({
    super.key,
    required this.onPress,
    required this.type,
  });

  @override
  State<UnfilledButton> createState() => _UnfilledButtonState();
}

class _UnfilledButtonState extends State<UnfilledButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              widget.onPress();
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFF0057FF)),
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                widget.type == 'logIn' ? 'Создать аккаунт' : 'Авторизация',
                style: const TextStyle(
                    color: Color(0xFF0057FF), fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
