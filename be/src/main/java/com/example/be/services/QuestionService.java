package com.example.be.services;

import com.example.be.database.dao.QuestionDao;
import com.example.be.database.dao.TestDao;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class QuestionService {

    private final QuestionDao questionDao;
    private final TestDao testDao;


}