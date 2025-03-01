import 'dart:convert';

import 'package:api_task/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> saveUsers(List<UserModel> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'cached_users',
      jsonEncode(users.map((user) => user.toJson()).toList()),
    );
  }

  Future<List<UserModel>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();

    List<dynamic> data = jsonDecode(prefs.getString('cached_users')!);
    return data.map((json) => UserModel.fromJson(json)).toList();
  }
}
