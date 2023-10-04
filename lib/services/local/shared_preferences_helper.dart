import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/authen.dart';
import '../../models/todo_model.dart';

class SharedPreferencesHelper {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _isLoginKey = 'isLogin';

  static Future<void> saveAuthenData(
      String username, String password, bool isLogin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
    await prefs.setBool(_isLoginKey, isLogin);
  }

  static Future<void> loadAuthenData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Authen.username = prefs.getString(_usernameKey);
    Authen.password = prefs.getString(_passwordKey);
    Authen.isLogin = prefs.getBool(_isLoginKey);
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<TodoModel>?> getTodos() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('todos');
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<TodoModel> todos = maps.map((e) => TodoModel.fromJson(e)).toList();
    return todos;
  }

  Future<void> addTodos(List<TodoModel> todos) async {
    List<Map<String, dynamic>> maps = todos.map((e) => e.toJson()).toList();
    SharedPreferences prefs = await _prefs;
    prefs.setString('todos', jsonEncode(maps));
  }
}
