import 'package:flutter/material.dart';

import '../../models/test_section.dart';
import '../../widgets/test_section_card.dart';

class SkillTestScreen extends StatelessWidget {
  final List<TestSection> sections = [
    TestSection(
      title: "Part 1: Pictures",
      description:
          "For each picture, you will hear 04 descriptive sentences about it. Your task is to choose the most accurate description for the picture.",
      icon: Icons.image,
      color: Colors.purple.shade700,
      testCount: 72,
    ),
    TestSection(
      title: "Part 2: Question-Response",
      description:
          "You will hear a question (or statement) and 03 answer choices. Your task is to select the most correct answer from the three options A-B-C.",
      icon: Icons.question_answer,
      color: Colors.purple.shade600,
      testCount: 25,
    ),
    TestSection(
      title: "Part 3: Short Conversations",
      description:
          "You will hear short conversations. Each conversation has 03 questions. Your task is to choose the most correct answer from the 04 options provided in the test.",
      icon: Icons.chat,
      color: Colors.purple.shade500,
      testCount: 28,
    ),
    TestSection(
      title: "Part 4: Short Talks",
      description:
          "You will hear short informational passages. Each passage has 03 questions. Your task is to choose the most correct answer from the 04 options provided.",
      icon: Icons.message,
      color: Colors.purple.shade400,
      testCount: 22,
    ),
    TestSection(
      title: "Part 5: Short Talks",
      description:
          "You will hear short informational passages. Each passage has 03 questions. Your task is to choose the most correct answer from the 04 options provided.",
      icon: Icons.message,
      color: Colors.purple.shade400,
      testCount: 22,
    ),
    TestSection(
      title: "Part 6: Short Talks",
      description:
          "You will hear short informational passages. Each passage has 03 questions. Your task is to choose the most correct answer from the 04 options provided.",
      icon: Icons.message,
      color: Colors.purple.shade400,
      testCount: 22,
    ),
    TestSection(
      title: "Part 7: Short Talks",
      description:
          "You will hear short informational passages. Each passage has 03 questions. Your task is to choose the most correct answer from the 04 options provided.",
      icon: Icons.message,
      color: Colors.purple.shade400,
      testCount: 22,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Skill Test',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade100, Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            return TestSectionCard(section: sections[index]);
          },
        ),
      ),
    );
  }
}
