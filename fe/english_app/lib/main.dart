import 'package:english_app/providers/auth_provider.dart';
import 'package:english_app/ui/admin/add_answer_screen.dart';
import 'package:english_app/ui/admin/add_question_screen.dart';
import 'package:english_app/ui/admin/home_screen.dart';
import 'package:english_app/ui/admin/import_exam_screen.dart';
import 'package:english_app/ui/home/home_screen.dart';
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
      home: const HomeScreen(),
      initialRoute: '/admin',
      routes: {
        '/admin': (context) => AdminScreen(),
        '/add_question': (context) => AddQuestionScreen(),
        '/import_exam': (context) => ImportExamScreen(),
        '/add_answer': (context) => AddAnswerScreen(),
      },
    );
  }
}
