import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  static final storage = FlutterSecureStorage();
  dynamic userInfo = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
  }

  logout() async {
    await storage.delete(key: "login");
    print("로그인 해제");
  }

  checkUserState() async {
    userInfo = storage.read(key: "login");
    if (userInfo == null) {
      print("로그인페이지로 이동");
      Navigator.pushNamed(context, "/");
    } else {
      print("로그인 되어 있음");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("main"),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: Icon(Icons.logout),
            tooltip: "logout",
          )
        ],
      ),
    );
  }
}
