import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unichmi/input.dart';
import 'package:unichmi/passInput.dart';
import 'package:unichmi/unfilledButton.dart';
import 'package:unichmi/university.dart';
import 'package:url_launcher/url_launcher.dart';

import 'filledButton.dart';

void main() {
  runApp(const MaterialApp(home: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

late String accessToken;

class _AppState extends State<App> {
  void signUp() async {
    final url = Uri.parse('http://localhost:4000/api/auth/create');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": mail,
          "name": name,
          "password": pass,
        }),
      );
      log(response.body);
      if (response.statusCode == 200) {
        accessToken = jsonDecode(response.body)['token'];
        isSigned = true;
        setState(() {});
        log(accessToken);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void logIn() async {
    final url = Uri.parse('http://localhost:4000/api/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": mail,
          "password": pass,
        }),
      );
      log(response.body);
      if (response.statusCode == 200) {
        accessToken = jsonDecode(response.body)['token'];
        isSigned = true;
        setState(() {});
        log(accessToken);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<University>> getData() async {
    final url = Uri.parse('http://localhost:4000/api/university/get');
    try {
      List<University> universityList = [];
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> universities = jsonDecode(response.body);
        for (final uni in universities["universites"]) {
          final university = University.fromJSon(uni);
          universityList.add(university);
        }
        return universityList;
      }
    } catch (error) {
      log(error.toString());
    }
    throw Error();
  }

  void waitForUnis() async {
    universityList = await getData();
    isLoading = false;
    setState(() {});
  }

  List<University> universityList = [];
  bool isLoading = true;
  final tgUrl =
      Uri.parse('https://web.telegram.org/k/#@UniversityControlSystemBot');
  @override
  void initState() {
    super.initState();
    waitForUnis();
  }

  String name = '';
  String mail = '';
  String pass = '';

  void showSignUp() {
    showDialog(
        context: context,
        builder: (_) {
          name = '';
          mail = '';
          pass = '';
          return AlertDialog(
            content: SizedBox(
              height: 375,
              width: 250,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      'Регистрация',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextInputWidget(
                        changeData: ({required String data}) {
                          name = data;
                        },
                        placeholder: 'Имя'),
                    const SizedBox(
                      height: 10,
                    ),
                    TextInputWidget(
                        changeData: ({required String data}) {
                          mail = data;
                        },
                        placeholder: 'Почта'),
                    const SizedBox(
                      height: 10,
                    ),
                    PassInputWidget(changeData: ({required String data}) {
                      pass = data;
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    FilledBlueButton(
                      mail: mail,
                      password: pass,
                      name: name,
                      type: 'signUp',
                      onPress: () {
                        signUp();
                        Navigator.pop(_);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    UnfilledButton(
                        onPress: () {
                          Navigator.pop(_);
                          showLogin();
                        },
                        type: 'SignUp')
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showLogin() {
    showDialog(
        context: context,
        builder: (_) {
          name = '';
          mail = '';
          pass = '';
          return AlertDialog(
            content: SizedBox(
              height: 375,
              width: 250,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      'Авторизация',
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextInputWidget(
                        changeData: ({required String data}) {
                          mail = data;
                        },
                        placeholder: 'Почта'),
                    const SizedBox(
                      height: 10,
                    ),
                    PassInputWidget(changeData: ({required String data}) {
                      pass = data;
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    FilledBlueButton(
                      mail: mail,
                      password: pass,
                      name: name,
                      type: 'logIn',
                      onPress: () {
                        logIn();
                        Navigator.pop(_);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    UnfilledButton(
                        onPress: () {
                          Navigator.pop(_);
                          showSignUp();
                        },
                        type: 'logIn')
                  ],
                ),
              ),
            ),
          );
        });
  }

  bool isSigned = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 4;
    bool isDesktop = MediaQuery.of(context).size.width >= 700;

    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 1920),
              child: Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF2F2F2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? width : 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                !isSigned ? showLogin() : null;
                              },
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.supervised_user_circle_outlined,
                                    size: 30,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    isSigned ? name : 'Войти',
                                    style: const TextStyle(fontSize: 30),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => launchUrl(tgUrl),
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 15, 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text('телеграм бот'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? width : 25),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          SizedBox(
                            height: isDesktop ? 75 : 50,
                          ),
                          const Text(
                            'Мониторинг работоспособности сайтов ВУЗов в реальном времени',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w600),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFFF2F2F2),
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: width * 4 > 1000 ? 25 : 20,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? width : 25),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'ВУЗ',
                                  style: TextStyle(
                                    color: Color(0xFF525252),
                                  ),
                                ),
                                Text(
                                  'Статус',
                                  style: TextStyle(
                                    color: Color(0xFF525252),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            isLoading
                                ? Container(
                                    padding: const EdgeInsets.all(25),
                                    child: const CircularProgressIndicator(),
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: isDesktop ? width : 25),
                                    height: universityList.length * 72,
                                    child: ListView.builder(
                                      itemCount: universityList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: const BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                color: Color(0xFFF2F2F2),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    universityList[index].name),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: universityList[
                                                                    index]
                                                                .isWorking
                                                            ? const Color(
                                                                0xFF008D0C)
                                                            : const Color(
                                                                0xFF8D0000)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80),
                                                    color: universityList[index]
                                                            .isWorking
                                                        ? const Color(
                                                            0xFFE5FFE8)
                                                        : const Color(
                                                            0xFFFFE5E5),
                                                  ),
                                                  child: Text(
                                                    universityList[index]
                                                            .isWorking
                                                        ? 'Всё в порядке'
                                                        : 'Что-то не так',
                                                    style: TextStyle(
                                                        color: universityList[
                                                                    index]
                                                                .isWorking
                                                            ? const Color(
                                                                0xFF008D0C)
                                                            : const Color(
                                                                0xFF8D0000)),
                                                  ),
                                                )
                                              ]),
                                        );
                                      },
                                    ),
                                  ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop ? width : 25),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F2F2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text(
                                      'Оставить заявку на добавление ВУЗа'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
