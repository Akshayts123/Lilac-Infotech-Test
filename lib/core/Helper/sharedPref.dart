import 'package:shared_preferences/shared_preferences.dart';

final DARK = "DARK";
final Name = "Name";
final Email = "Email";
final DOB = "DOB";
final VIDEOPATH = "dowlodedPath";
final IMG = "userImage";
final IMAGEPATH = "imagePath";
Future setSharedPrefrence(key, data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, data);

  return data;
}

Future getSharedPrefrence(key) async {
  var prefs = await SharedPreferences.getInstance();
  var value = prefs.getString(key);

  return value;
}
