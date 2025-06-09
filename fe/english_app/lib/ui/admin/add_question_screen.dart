import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answer1Controller = TextEditingController();
  final _answer2Controller = TextEditingController();
  final _answer3Controller = TextEditingController();
  final _answer4Controller = TextEditingController();
  int _correctAnswer = 1;
  String _message = '';

  void _addQuestion() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _message = 'Đã thêm câu hỏi: ${_questionController.text}';
      });
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answer1Controller.dispose();
    _answer2Controller.dispose();
    _answer3Controller.dispose();
    _answer4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm câu hỏi')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thêm câu hỏi mới',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Câu hỏi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập câu hỏi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text('Đáp án:'),
              TextFormField(
                controller: _answer1Controller,
                decoration: InputDecoration(
                  labelText: 'Đáp án 1',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập đáp án';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _answer2Controller,
                decoration: InputDecoration(
                  labelText: 'Đáp án 2',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập đáp án';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _answer3Controller,
                decoration: InputDecoration(
                  labelText: 'Đáp án 3',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập đáp án';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _answer4Controller,
                decoration: InputDecoration(
                  labelText: 'Đáp án 4',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập đáp án';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButton<int>(
                value: _correctAnswer,
                hint: Text('Chọn đáp án đúng'),
                items: [
                  DropdownMenuItem(value: 1, child: Text('Đáp án 1')),
                  DropdownMenuItem(value: 2, child: Text('Đáp án 2')),
                  DropdownMenuItem(value: 3, child: Text('Đáp án 3')),
                  DropdownMenuItem(value: 4, child: Text('Đáp án 4')),
                ],
                onChanged: (value) {
                  setState(() {
                    _correctAnswer = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text('Thêm câu hỏi'),
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
