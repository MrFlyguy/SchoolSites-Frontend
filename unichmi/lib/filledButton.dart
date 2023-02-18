import 'package:flutter/material.dart';

class FilledBlueButton extends StatefulWidget {
  final String type;
  final String? name;
  final String mail;
  final String password;
  final void Function() onPress;
  const FilledBlueButton(
      {super.key,
      required this.onPress,
      required this.type,
      this.name,
      required this.mail,
      required this.password});

  @override
  State<FilledBlueButton> createState() => _FilledBlueButtonState();
}

class _FilledBlueButtonState extends State<FilledBlueButton> {
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
                  color: const Color(0xFF0057FF),
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Text(
                widget.type == 'logIn' ? 'Войти' : 'Зарегистрироваться',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
