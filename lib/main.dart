import 'package:flutter/material.dart';
import 'package:flutter_app/screens/loading_screen.dart';
// Home ekranı için tek bir import kullanın - yol projenize göre doğruysa
import 'package:flutter_app/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Döviz Dönüştürücü',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const LoadingScreen(), // HomeScreen yerine LoadingScreen kullanın
      debugShowCheckedModeBanner: false,
    );
  }
}