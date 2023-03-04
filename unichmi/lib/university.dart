class University {
  final String name;
  final bool isWorking;
  final String url;
  final String id;
  final List comments;
  final double rating;

  University.fromJSon(Map<String, dynamic> json)
      : name = json['title'],
        isWorking = json['isAccessible'],
        url = json['url'],
        comments = json['comments'],
        rating = json['rating'],
        id = json['_id'];
}
