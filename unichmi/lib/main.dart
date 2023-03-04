import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  void doRating() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/auth/rating');
    try {
      final response = await http.post(url,
          headers: {
            'token': accessToken,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "rating": uniRating.toString(),
            "universityId": uniId,
          }));
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  void doComment() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/auth/comment');
    try {
      final response = await http.post(url,
          headers: {
            'token': accessToken,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "universityId": uniId,
            "text": commentText,
          }));
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  void doSubscribe() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/auth/subscribe');
    try {
      final response = await http.post(url,
          headers: {
            'token': accessToken,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "universityId": uniId,
          }));
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  void doUnsubscrive() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/auth/subscribe');
    try {
      final response = await http.post(url,
          headers: {
            'token': accessToken,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "universityId": uniId,
          }));
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  void doRequest() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/application/create');
    try {
      final response = await http.post(url,
          headers: {
            'token': accessToken,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'title': uniName,
            'url': uniUrl,
          }));
      log(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  void signUp() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/auth/create');
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
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/auth/login');
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
        name = jsonDecode(response.body)['name'];
        isAdmin = !(jsonDecode(response.body)['roles'][0] == 'USER');

        isSigned = true;
        log(accessToken);
        setState(() {});
        log(accessToken);
        log(isAdmin.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> checkRequest() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/application/distribute');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'token': accessToken,
          },
          body: jsonEncode({"applicationId": requestID, "add": isAccepted}));
      log(response.body);
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getRequests() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/application/get');
    try {
      final response = await http.get(url, headers: {
        'token': accessToken,
      });
      requests = jsonDecode(response.body)['applications'];
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getUniRating() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/auth/getRating');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "universityId": uniId,
          }));
      uniRating = jsonDecode(response.body)['rating'] / 2;
      log(uniRating.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> getUniComms() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/auth/getComments');
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "universityId": uniId,
          }));
      comments = jsonDecode(response.body)['comments'];
      setState(() {});
      log(comments.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<University>> getData() async {
    final url = Uri.parse(
        'https://universities-control-system.onrender.com/api/university/get');
    try {
      List<University> universityList = [];
      final response = await http.get(url);
      log(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> universities = jsonDecode(response.body);
        for (final uni in universities["universities"]) {
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

  void waitForUni() async {
    await getUniComms();
    await getUniRating();
    isCommsLoading = false;
    setState(() {});
    showComments();
  }

  Future<void> waitForRequests() async {
    await getRequests();
    isRequestsLoading = false;
    setState(() {});
    showRequests();
  }

  void waitForUnis() async {
    universityList = await getData();
    isLoading = false;
    setState(() {});
  }

  List<University> universityList = [];
  bool isLoading = true;
  bool isCommsLoading = false;
  bool isRequestsLoading = true;
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
  String uniUrl = '';
  String uniName = '';
  String commentText = '';
  String uniId = '';
  double uniRating = 0;
  List comments = [];
  List requests = [];
  String requestID = '';
  bool isAccepted = false;

  void logOut() {
    isAdmin = false;
    accessToken = '';
    isSigned = false;
    setState(() {});
  }

  void showRequests() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              width: 350,
              height: 500,
              padding: const EdgeInsets.all(15),
              child: Center(
                  child: ListView(
                children: [
                  const Text(
                    'Заявки на модерацию',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                        itemCount: requests.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border:
                                              Border.all(color: Colors.black)),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                requests[index]['title']
                                                            .length <=
                                                        15
                                                    ? requests[index]['title']
                                                    : '${requests[index]['title'].substring(0, 15)}...',
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                              Text(
                                                requests[index]['url'].length <=
                                                        15
                                                    ? requests[index]['url']
                                                    : '${requests[index]['url'].substring(0, 15)}...',
                                                style: const TextStyle(
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () async {
                                                    isAccepted = true;
                                                    requestID =
                                                        requests[index]['_id'];
                                                    await checkRequest();
                                                    Navigator.pop(_);
                                                    await waitForRequests();
                                                  },
                                                  icon: const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  )),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    isAccepted = false;
                                                    requestID =
                                                        requests[index]['_id'];
                                                    checkRequest();
                                                    Navigator.pop(_);
                                                    showRequests();
                                                    waitForRequests();
                                                  },
                                                  icon: const Icon(
                                                    Icons.block,
                                                    color: Colors.red,
                                                  ))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        }),
                  ),
                ],
              )),
            ),
          );
        });
  }

  void showComments() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              height: 500,
              width: 350,
              padding: const EdgeInsets.all(15),
              child: Center(
                child: ListView(children: [
                  const Text(
                    'Рейтинг',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: isCommsLoading
                        ? const CircularProgressIndicator()
                        : RatingBar.builder(
                            ignoreGestures: true,
                            initialRating: uniRating.toDouble(),
                            itemBuilder: (context, rating) => const Icon(
                                  Icons.star_outlined,
                                  color: Colors.amber,
                                ),
                            onRatingUpdate: (rating) {}),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  isSigned
                      ? const Text(
                          'Управление подпиской',
                          style: TextStyle(fontSize: 30),
                          textAlign: TextAlign.center,
                        )
                      : Container(),
                  isSigned
                      ? const SizedBox(
                          height: 15,
                        )
                      : Container(),
                  isSigned
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  doSubscribe();
                                },
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 25,
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.block,
                                  color: Colors.red,
                                  size: 25,
                                ))
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Отзывы',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  isSigned
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              splashRadius: 0.1,
                              onPressed: () {
                                Navigator.pop(_);
                                showComment();
                              },
                              icon: const Icon(
                                Icons.add_box_outlined,
                                size: 30,
                              ),
                            )
                          ],
                        )
                      : Container(),
                  isSigned
                      ? const SizedBox(
                          height: 10,
                        )
                      : Container(),
                  SizedBox(
                    height: 250,
                    child: isCommsLoading
                        ? const CircularProgressIndicator()
                        : ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: ((context, index) {
                              log(comments[index]['text']);
                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border:
                                            Border.all(color: Colors.black)),
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      comments[index]['text'],
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              );
                            }),
                          ),
                  )
                ]),
              ),
            ),
          );
        });
  }

  void showComment() {
    uniRating = 0;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              height: 250,
              width: 200,
              padding: const EdgeInsets.all(15),
              child: Column(children: [
                const Text(
                  'Ваш отзыв',
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  height: 15,
                ),
                RatingBar.builder(
                  maxRating: 5,
                  minRating: 1,
                  itemCount: 5,
                  itemBuilder: (context, rating) => const Icon(
                    Icons.star_outlined,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (value) => {uniRating = value.toDouble() * 2},
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  onChanged: (value) => {commentText = value},
                ),
                const SizedBox(
                  height: 20,
                ),
                FilledBlueButton(
                    onPress: () {
                      doComment();
                      uniRating != 0 ? doRating() : null;
                      Navigator.pop(_);
                    },
                    type: 'request')
              ]),
            ),
          );
        });
  }

  void showRequest() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              height: 250,
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'Заявка на добавление ВУЗа',
                      style: TextStyle(fontSize: 25),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextInputWidget(
                        changeData: ({required String data}) {
                          uniUrl = data;
                        },
                        placeholder: 'Сайт ВУЗа'),
                    const SizedBox(
                      height: 10,
                    ),
                    TextInputWidget(
                        changeData: ({required String data}) {
                          uniName = data;
                        },
                        placeholder: 'Название ВУЗа'),
                    const SizedBox(
                      height: 15,
                    ),
                    FilledBlueButton(
                      onPress: () {
                        doRequest();
                        Navigator.pop(_);
                      },
                      type: 'request',
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void showlogOut() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Container(
              height: isAdmin ? 225 : 150,
              padding: const EdgeInsets.all(15),
              child: Center(
                child: Column(children: [
                  isAdmin
                      ? InkWell(
                          onTap: () {
                            Navigator.pop(_);
                            waitForRequests();
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  child: const Text(
                                    'Посмотреть заявки',
                                    style: TextStyle(color: Colors.red),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(),
                  isAdmin
                      ? const SizedBox(
                          height: 15,
                        )
                      : Container(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(_);
                      showLogin();
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.all(15),
                            child: const Text(
                              'Сменить аккаунт',
                              style: TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      logOut();
                      Navigator.pop(_);
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.red,
                            ),
                            padding: const EdgeInsets.all(15),
                            child: const Text(
                              'Выйти',
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              ),
            ),
          );
        });
  }

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
                child: Center(
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
              height: 325,
              width: 250,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
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
                        type: 'logIn',
                        onPress: () {
                          logIn();
                          Navigator.pop(_);
                          setState(() {});
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
            ),
          );
        });
  }

  bool isSigned = false;
  bool isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 4;
    bool isDesktop = MediaQuery.of(context).size.width >= 700;

    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            children: [
              Container(
                height: 75,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2F2F2),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: isDesktop ? width : 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          !isSigned ? showLogin() : showlogOut();
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
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
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
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: isDesktop ? width : 25),
                decoration: const BoxDecoration(color: Colors.white),
                child: Column(
                  children: [
                    SizedBox(
                      height: isDesktop ? 75 : 50,
                    ),
                    const Text(
                      'Мониторинг работоспособности сайтов ВУЗов в реальном времени',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 50,
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
              Column(
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
                              height: universityList.length * 69,
                              padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop ? width : 25),
                              child: ListView.builder(
                                itemCount: universityList.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      if (!isCommsLoading) {
                                        uniId = universityList[index].id;
                                        isCommsLoading = true;
                                        setState(() {});
                                        waitForUni();
                                      }
                                    },
                                    child: Container(
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              universityList[index]
                                                          .name
                                                          .length <=
                                                      27
                                                  ? universityList[index].name
                                                  : '${universityList[index].name.substring(0, 27)}...',
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: universityList[index]
                                                            .isWorking
                                                        ? const Color(
                                                            0xFF008D0C)
                                                        : const Color(
                                                            0xFF8D0000)),
                                                borderRadius:
                                                    BorderRadius.circular(80),
                                                color: universityList[index]
                                                        .isWorking
                                                    ? const Color(0xFFE5FFE8)
                                                    : const Color(0xFFFFE5E5),
                                              ),
                                              child: Text(
                                                universityList[index].isWorking
                                                    ? 'Всё в порядке'
                                                    : 'Что-то не так',
                                                style: TextStyle(
                                                    color: universityList[index]
                                                            .isWorking
                                                        ? const Color(
                                                            0xFF008D0C)
                                                        : const Color(
                                                            0xFF8D0000)),
                                              ),
                                            )
                                          ]),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? width : 25),
                    child: InkWell(
                      onTap: isSigned
                          ? () {
                              showRequest();
                            }
                          : () {
                              showLogin();
                            },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(isSigned
                              ? 'Оставить заявку на добавление ВУЗа'
                              : 'Войти, чтобы оставить заявку на добавление ВУЗа'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 150,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
