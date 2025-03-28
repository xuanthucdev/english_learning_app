package com.example.be.controller;


import com.example.be.common.repository.TestRepository;
import com.example.be.database.entity.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;


@RestController
@RequestMapping("api/tests")
public class TestController  {
    @Autowired
    private TestRepository testRepository;
    @GetMapping
    public List<Test> getAllTests() {
        return testRepository.findAll();
    }
}
