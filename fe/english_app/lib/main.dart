import 'package:english_app/ui/onboarding/onboarding_child_page.dart';
import 'package:english_app/ultils.enums/onboarding_page_position.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyEnglishApp());
}

class MyEnglishApp extends StatelessWidget {
  const MyEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo",
      home: OnboardingChildPage(
        onboardingPagePosition: OnboardingPagePosition.page1,
        nextOnPressed: () {},
      ),
    );
  }
}
