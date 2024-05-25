class MyNotification {
  int _id;
  String _name;
  String _message;
  int _hasImage;
  String _image;

  MyNotification(
      {required int id,
      required String name,
      required String message,
      required int hasImage,
      required String image})
      : _id = id,
        _name = name,
        _message = message,
        _hasImage = hasImage,
        _image = image;

  // Getters
  int get id => _id;
  String get name => _name;
  String get message => _message;
  int get hasImage => _hasImage;
  String get image => _image;

  factory MyNotification.fromJson(Map<String, dynamic> json) {
    return MyNotification(
      id: json['id'] as int,
      name: json['name'] as String,
      message: json['message'] as String,
      hasImage: json['hasImage'] as int,
      image: json['imageBase64'] as String,
    );
  }
}
