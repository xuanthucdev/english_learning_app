package com.example.be.services;

import com.example.be.DTO.response.TestReponseDto;
import com.example.be.database.dao.TestDao;
import com.example.be.database.entities.Test;
import com.example.be.database.enums.TestType;
import com.example.be.mappers.TestMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TestService {

    private final TestDao testDao;
    private final TestMapper testMapper;
    public List<Test> getAllTest() {
        return (List<Test>) testDao.findAll();
    }

    public List<Test> getFullTests() {
        return testDao.findByTestType(TestType.FULL_TEST);
    }
    public List<TestReponseDto> getFullTestsDTO() {
        List<Test> tests = testDao.findByTestType(TestType.FULL_TEST);
        return testMapper.testsToTestDTOs(tests);
    }
    public List<Test> getAPTests() {
        return testDao.findByTestType(TestType.APTITUDE_TEST);
    }
    public List<Test> getMiniTests() {
        return testDao.findByTestType(TestType.MINI_TEST);
    }




}
