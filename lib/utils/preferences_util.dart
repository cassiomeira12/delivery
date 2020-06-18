import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil {
  static String _THEME = "theme";
  static String _NOTIFICATION_TOKEN = "notification_token";
  static String _LAST_CHECK_UPDATE = "last_check_update";
  static String _INTRO_DONE = "intro_done";
  static String _USER_DATA = "user_data";
  static String _STATE_DATA = "state_data";
  static String _CITY_DATA = "city_data";
  static String _SMALL_TOWN_DATA = "small_town_data";

  static Future<SharedPreferences> getInstance() {
    return SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> setTheme(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_THEME, value);
  }

  static Future<String> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_THEME);
  }

  static void setNotificationToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_NOTIFICATION_TOKEN, value);
  }

  static Future<String> getNotificationToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_NOTIFICATION_TOKEN);
  }

  static void setLastCheckUpdate(DateTime value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_LAST_CHECK_UPDATE, value.millisecondsSinceEpoch);
  }

  static Future<DateTime> getLastCheckUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var milisSeconds = prefs.getInt(_LAST_CHECK_UPDATE);
    if (milisSeconds == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(milisSeconds);
  }

  static void setIntroDone(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(_INTRO_DONE, value);
  }

  static Future<bool> getIntroDone() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_INTRO_DONE);
  }

  static void setUserData(Map<dynamic, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_USER_DATA, value == null ? null : json.encode(value));
  }

  static Future<dynamic> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(_USER_DATA);
    return result == null ? null : json.decode(result);
  }

  static void setStateData(Map<dynamic, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_STATE_DATA, value == null ? null : json.encode(value));
  }

  static Future<dynamic> getStateData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(_STATE_DATA);
    return result == null ? null : json.decode(result);
  }

  static void setCityData(Map<dynamic, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_CITY_DATA, value == null ? null : json.encode(value));
  }

  static Future<dynamic> getCityData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(_CITY_DATA);
    return result == null ? null : json.decode(result);
  }

  static void setSmallTownData(Map<dynamic, dynamic> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_SMALL_TOWN_DATA, value == null ? null : json.encode(value));
  }

  static Future<dynamic> getSmallTownData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getString(_SMALL_TOWN_DATA);
    return result == null ? null : json.decode(result);
  }

}