import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secure_storage_practice/models/login_model.dart';
import 'package:secure_storage_practice/models/service_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/service': (context) => ServicePage()
      },
    );
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

      Response response =
          await dio.post("http://localhost:5000/api/login", data: param);

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
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        TextField(
          controller: username,
          decoration: InputDecoration(
            labelText: "Username",
          ),
        ),
        TextField(
          controller: password,
          decoration: InputDecoration(labelText: "password"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (await loginAction(username.text, password.text)) {
              print("로그인 성공");
              Navigator.pushNamed(context, "/service");
            } else {
              print("로그인 실패");
            }
          },
          child: Text("로그인"),
        ),
      ],
    ));
  }
}
