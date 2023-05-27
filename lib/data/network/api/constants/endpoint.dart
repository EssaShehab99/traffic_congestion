class Collection {
  Collection._privateConstructor();
  static final Collection _instance = Collection._privateConstructor();
  static Collection get instance => _instance;

  static const int connectionTimeout = 300;
  static const users = 'users';
  static const roads = 'roads';
  static const parking = 'parking';

}