package com.example.be.controllers;

import com.example.be.DTO.response.TestReponseDto;
import com.example.be.database.entities.Test;
import com.example.be.database.enums.TestType;
import com.example.be.services.TestService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/tests")
public class TestController {

    private final TestService testService;

    @GetMapping
    public List<Test> getAllTests() {
        return testService.getAllTest();
    }
    @GetMapping("/fulltest")
    public ResponseEntity<List<TestReponseDto>> getFullTests() {
        List<TestReponseDto> fullTests = testService.getFullTestsDTO();
        return ResponseEntity.ok(fullTests);

    }
    @GetMapping("/aptitudetest")
    public ResponseEntity<List<Test>> getAptitudeTests() {
        List<Test> apTests = testService.getAPTests();
        return ResponseEntity.ok(apTests);
    }
    @GetMapping("/minitest")
    public ResponseEntity<List<Test>> getMiniTests() {
        List<Test> miniTests = testService.getMiniTests();
        return ResponseEntity.ok(miniTests);
    }
}
