import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  static String sharedPreferenceUserNameKey='USERNAMEKEY';
  static String sharedPreferenceUserEmailKey='USEREMAILKEY';

  static Future<bool> saveUserNameSharedPreference(String username)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, username);
  }
  static Future<bool> saveUserEmailSharedPreference(String useremail)async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, useremail);
  }
  static Future<String?> getUserNameSharedPreference()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    return await prefs.getString(sharedPreferenceUserEmailKey);
  }
}