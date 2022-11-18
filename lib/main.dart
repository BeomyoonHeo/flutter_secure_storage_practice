import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_storage_practice/models/login_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    userInfo = await storage.read(key: 'login');
    if (userInfo != null) {
      Navigator.pushNamed(context, "/main");
    }
  }

  loginAction(username, password) async {
    try {
      final dio = Dio();
      final param = {"username": "${username}", "password": "${password}"};

      Response response = await dio.post("", data: param);

      if (response.statusCode == 200) {
        final value =
            jsonEncode(LoginModel(username: username, password: password));
        await storage.write(key: "login", value: value);
        print("접속 성공");
        return true;
      } else {
        print("error");
        return false;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
