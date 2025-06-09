import 'package:flutter/material.dart';

class AddAnswerScreen extends StatefulWidget {
  @override
  _AddAnswerScreenState createState() => _AddAnswerScreenState();
}

class _AddAnswerScreenState extends State<AddAnswerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _answerController = TextEditingController();
  String _message = '';

  void _addAnswer() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _message = 'Đã thêm câu trả lời: ${_answerController.text}';
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm câu trả lời')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thêm câu trả lời',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _answerController,
                decoration: InputDecoration(
                  labelText: 'Câu trả lời',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập câu trả lời';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addAnswer,
                child: Text('Thêm câu trả lời'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
              SizedBox(height: 16),
              Text(
                _message,
                style: TextStyle(
                  color: _message.contains('Lỗi') ? Colors.red : Colors.green,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
