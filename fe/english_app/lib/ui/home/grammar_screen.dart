import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:english_app/core/services/grammar_service.dart';
import 'package:english_app/models/grammar_model.dart';

class GrammarScreen extends StatefulWidget {
  @override
  _GrammarScreenState createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  late Future<List<Grammar>> _grammarFuture;

  final String apiKey = 'AIzaSyDoBgifqtv2IWCod1FbOeqDYG0uvGNknBs';

  @override
  void initState() {
    super.initState();
    _grammarFuture = GrammarService.fetchGrammarTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grammar Lessons',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: Colors.purple,
        elevation: 3,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Grammar>>(
            future: _grammarFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final grammarList = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Learn English Grammar',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore grammar topics with examples and explanations.',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: grammarList.length,
                      itemBuilder: (context, index) {
                        return _buildGrammarCard(grammarList[index]);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGrammarCard(Grammar word) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Colors.purple.shade100,
          child: Icon(Icons.menu_book, color: Colors.purple),
        ),
        title: Text(
          word.word,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          word.topic,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(Icons.info_outline, 'Definition'),
                const SizedBox(height: 4),
                Text(
                  word.definition,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 12),
                _buildSectionTitle(Icons.lightbulb_outline, 'Example'),
                const SizedBox(height: 6),
                Text(
                  '“${word.example}”',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                _buildSectionTitle(Icons.tag, 'Additional Info'),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildBadge('Difficulty: ${word.difficulty}'),
                    _buildBadge('TOEIC: ${word.toeicFrequency}'),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      _showChatWithAI(word);
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text("Hỏi AI"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.deepPurple.shade700),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.purple.shade100),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: Colors.deepPurple),
      ),
    );
  }

  void _showChatWithAI(Grammar word) {
    final TextEditingController _chatController = TextEditingController();
    List<Map<String, String>> messages = [
      {
        'role': 'user',
        'text':
            'Bạn là một trợ lý chuyên giảng dạy ngữ pháp tiếng Anh.\nHãy giải thích chi tiết về: ${word.word} - ${word.definition}\nVídụ : ${word.example}'
      }
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 450,
              child: Column(
                children: [
                  const Text("AI Assistant",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (_, index) {
                        final msg = messages[index];
                        return Align(
                          alignment: msg['role'] == 'user'
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: msg['role'] == 'user'
                                  ? Colors.purple.shade100
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(msg['text'] ?? ''),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _chatController,
                          decoration: const InputDecoration(
                              hintText: "Nhập câu hỏi..."),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () async {
                          final text = _chatController.text.trim();
                          if (text.isNotEmpty) {
                            setModalState(() {
                              messages.add({'role': 'user', 'text': text});
                            });

                            final reply = await _askGemini(messages);
                            setModalState(() {
                              messages.add({'role': 'bot', 'text': reply});
                            });
                            _chatController.clear();
                          }
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<String> _askGemini(List<Map<String, String>> history) async {
    final uri = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": history.map((msg) {
          final role = msg['role'] == 'bot'
              ? 'model'
              : (msg['role'] == 'system' ? 'user' : msg['role']);
          return {
            "role": role,
            "parts": [
              {"text": msg['text']}
            ]
          };
        }).toList()
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    } else {
      return "⚠️ Lỗi: ${response.body}";
    }
  }
}
