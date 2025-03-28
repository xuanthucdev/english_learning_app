package com.example.be.controller;

import com.example.be.common.repository.QuestionRepository;
import com.example.be.database.entity.Question;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/questions")
public class QuestionController {
    @Autowired
    private QuestionRepository questionRepository;

    @GetMapping("/{testId}")
    public List<Question> getQuestionsByTest(@PathVariable Long testId) {
        return questionRepository.findByTestId(testId);
    }
}
