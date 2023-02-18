class University {
  final String name;
  final bool isWorking;
  final String url;

  University.fromJSon(Map<String, dynamic> json)
      : name = json['title'],
        isWorking = json['isAccessible'],
        url = json['url'];
}
