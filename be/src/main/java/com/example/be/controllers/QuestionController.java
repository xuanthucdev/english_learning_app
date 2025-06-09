package com.example.be.controllers;

import com.example.be.DTO.request.QuestionRequestDTO;
import com.example.be.database.entities.Question;
import com.example.be.services.QuestionService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/questions")
@RequiredArgsConstructor
public class QuestionController {

    private final QuestionService questionService;



}