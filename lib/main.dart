import 'package:flutter/material.dart';
import 'package:flutter_app/core/routes.dart';
import 'package:flutter_app/screens/loading_screen.dart';

void main() {
  runApp(const FXSwiftApp());
}

class FXSwiftApp extends StatelessWidget {
  const FXSwiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FXSwift',
      debugShowCheckedModeBanner: false,
      home: const SplashWrapper(), // İlk önce Splash yüklenir
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showRouter = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _showRouter = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showRouter) {
      return MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
        ),
      );
    } else {
      return const LoadingScreen();
    }
  }
}
