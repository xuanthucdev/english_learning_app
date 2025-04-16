import 'package:english_app/providers/auth_provider.dart';
import 'package:english_app/ui/login/login.dart';
import 'package:english_app/ui/signup/signUp.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyEnglishApp(),
    ),
  );
}

class MyEnglishApp extends StatelessWidget {
  const MyEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "English App",
      home: LoginScreen(),
    );
  }
}
