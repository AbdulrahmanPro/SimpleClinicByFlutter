class Baseural {
  static final Baseural _instance = Baseural._internal();

  factory Baseural() {
    return _instance;
  }

  Baseural._internal();

  static const String baseUrl = 'http://10.0.2.2:5029/api';
}
