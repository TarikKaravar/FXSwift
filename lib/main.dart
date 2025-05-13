import 'package:flutter/material.dart';
import 'package:flutter_app/core/routes.dart';
import 'package:flutter_app/core/routes.dart';
import '../widgets/bottom_menu.dart';// go_router yapılandırman burada olmalı

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Döviz Dönüştürücü',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      routerConfig: router, // go_router yapılandırması buradan geliyor
      debugShowCheckedModeBanner: false,
    );
  }
}
