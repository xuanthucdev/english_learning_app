import 'package:flutter/material.dart';

class GrammarScreen extends StatelessWidget {
  // Sample grammar data
  final List<GrammarTopic> grammarTopics = [
    GrammarTopic(
      title: 'Present Simple',
      description: 'Used to describe habits, general truths, and routines.',
      examples: [
        'She walks to school every day.',
        'The sun rises in the east.',
      ],
      explanation:
          'The present simple tense is formed using the base verb for I/you/we/they, and adding -s or -es for he/she/it.',
    ),
    GrammarTopic(
      title: 'Past Simple',
      description: 'Used to describe completed actions in the past.',
      examples: [
        'They visited Paris last summer.',
        'He didn’t play football yesterday.',
      ],
      explanation:
          'The past simple is typically formed by adding -ed to regular verbs, while irregular verbs have unique forms.',
    ),
    GrammarTopic(
      title: 'Future Simple',
      description: 'Used to talk about future actions or predictions.',
      examples: [
        'We will travel to Japan next year.',
        'It will probably rain this afternoon.',
      ],
      explanation:
          'The future simple is formed with "will" + base verb for all subjects.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grammar Lessons',
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Learn English Grammar',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Explore grammar topics with examples and explanations.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: grammarTopics.length,
                  itemBuilder: (context, index) {
                    final topic = grammarTopics[index];
                    return _buildGrammarCard(context, topic);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to a quiz or practice section
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Practice Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrammarCard(BuildContext context, GrammarTopic topic) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ExpansionTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.purple.shade100,
          child: Icon(
            Icons.school,
            size: 28,
            color: Colors.purple.shade700,
          ),
        ),
        title: Text(
          topic.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          topic.description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Explanation:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  topic.explanation,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Examples:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                ...topic.examples.map(
                  (example) => Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.purple.shade700,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            example,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GrammarTopic {
  final String title;
  final String description;
  final List<String> examples;
  final String explanation;

  GrammarTopic({
    required this.title,
    required this.description,
    required this.examples,
    required this.explanation,
  });
}
