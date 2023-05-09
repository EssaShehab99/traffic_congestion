class Collection {
  Collection._privateConstructor();
  static final Collection _instance = Collection._privateConstructor();
  static Collection get instance => _instance;

  static const int connectionTimeout = 300;
  static const users = 'users';
  static const services = 'services';
  static const helpers = 'helpers';
  static const areas = 'areas';
  static const event = 'events';
  static const request = 'request';
  static const hotel = 'hotel';

}