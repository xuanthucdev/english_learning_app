import 'package:flutter/material.dart';

import '../../models/test_section.dart';
import '../../widgets/test_section_card.dart';

class SkillTestScreen extends StatelessWidget {
  final List<TestSection> sections = [
    TestSection(
      title: "Phần 1: Hình Ảnh",
      description:
          "Tương ứng với mỗi bức ảnh, bạn sẽ được nghe 04 câu mô tả về nó. Nhiệm vụ của bạn là phải chọn câu mô tả đúng nhất cho bức ảnh.",
      icon: Icons.image,
      color: Colors.orange,
      testCount: 72,
    ),
    TestSection(
      title: "Phần 2: Hỏi đáp",
      description:
          "Bạn sẽ nghe một câu hỏi (hoặc câu nói) và 03 lựa chọn trả lời. Nhiệm vụ của bạn là phải chọn ra câu trả lời đúng nhất trong ba đáp án A-B-C.",
      icon: Icons.question_answer,
      color: Colors.red,
      testCount: 25,
    ),
    TestSection(
      title: "Phần 3: Hội thoại ngắn",
      description:
          "Bạn sẽ nghe các đoạn hội thoại ngắn. Mỗi đoạn có 03 câu hỏi. Nhiệm vụ của bạn là chọn ra câu trả lời đúng nhất trong 04 đáp án của đề thi.",
      icon: Icons.chat,
      color: Colors.blue,
      testCount: 28,
    ),
    TestSection(
      title: "Phần 4: Đoạn thông tin ngắn",
      description:
          "Bạn sẽ nghe các đoạn thông tin ngắn. Mỗi đoạn có 03 câu hỏi. Nhiệm vụ của bạn là chọn ra câu trả lời đúng nhất trong số 04 đáp án được cung cấp.",
      icon: Icons.message,
      color: Colors.lightBlue,
      testCount: 22,
    ),
    TestSection(
      title: "Phần 5: Đoạn thông tin ngắn",
      description:
          "Bạn sẽ nghe các đoạn thông tin ngắn. Mỗi đoạn có 03 câu hỏi. Nhiệm vụ của bạn là chọn ra câu trả lời đúng nhất trong số 04 đáp án được cung cấp.",
      icon: Icons.message,
      color: Colors.lightBlue,
      testCount: 22,
    ),
    TestSection(
      title: "Phần 6: Đoạn thông tin ngắn",
      description:
          "Bạn sẽ nghe các đoạn thông tin ngắn. Mỗi đoạn có 03 câu hỏi. Nhiệm vụ của bạn là chọn ra câu trả lời đúng nhất trong số 04 đáp án được cung cấp.",
      icon: Icons.message,
      color: Colors.lightBlue,
      testCount: 22,
    ),
    TestSection(
      title: "Phần 7: Đoạn thông tin ngắn",
      description:
          "Bạn sẽ nghe các đoạn thông tin ngắn. Mỗi đoạn có 03 câu hỏi. Nhiệm vụ của bạn là chọn ra câu trả lời đúng nhất trong số 04 đáp án được cung cấp.",
      icon: Icons.message,
      color: Colors.lightBlue,
      testCount: 22,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Skill Test")),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return TestSectionCard(section: sections[index]);
        },
      ),
    );
  }
}
