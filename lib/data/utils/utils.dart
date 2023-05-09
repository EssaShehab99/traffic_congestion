import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Utils {
  Utils._privateConstructor();
static final Utils _instance = Utils._privateConstructor();
static Utils get instance => _instance;
  static Future<bool> isConnected() async {
    try {
      List<InternetAddress> result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  static  bool validateEmail(String value){
    String  pattern = r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value.toLowerCase());
  }
  static Future<File?> saveFile(String contents, String folder,
      {String? fileName}) async {
    try {
      var directory = await getApplicationDocumentsDirectory();
      directory =
      await Directory('${directory.path}/$folder').create(recursive: true);
      final file = File(
          '${directory.path}/${fileName ?? DateTime.now().millisecondsSinceEpoch}');
      await file.writeAsBytes(Uint8List.fromList(contents.codeUnits));
      return file;
    } catch (_) {
      return null;
    }
  }
  static Future<String?> imageToBase64(String image) async {
    try {
      if (_isBase64(image)) {
        return image;
      }
      return await _networkImageToBase64(image);
    } catch (e) {
      return null;
    }
  }
  static Future<String?> _networkImageToBase64(String imageUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(imageUrl));
      return base64Encode(response.bodyBytes);
    } catch (e) {
      return null;
    }
  }

  static bool _isBase64(String? value) {
    String pattern =
        r'^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value ?? "");
  }
}
