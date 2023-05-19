import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Utils {
  Utils._privateConstructor();

  static final Utils _instance = Utils._privateConstructor();

  static Utils get instance => _instance;
}
