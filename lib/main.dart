import 'package:flutter/material.dart';
import 'package:flutter_app/core/routes.dart';
import 'package:flutter_app/screens/loading_screen.dart';
import 'package:flutter_app/theme_provider.dart';
import 'package:flutter_app/localization_provider.dart'; // YENİ EKLENEN
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider( // ChangeNotifierProvider yerine MultiProvider kullan
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocalizationProvider()), // YENİ EKLENEN
      ],
      child: const FXSwiftApp(),
    ),
  );
}

class FXSwiftApp extends StatelessWidget {
  const FXSwiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FXSwift',
      debugShowCheckedModeBanner: false,
      home: const SplashWrapper(),
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
      return Consumer<ThemeProvider>( // ThemeProvider'ı dinle
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Roboto',
              brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light, // Tema desteği
            ),
          );
        },
      );
    } else {
      return const LoadingScreen();
    }
  }
}