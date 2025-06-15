package com.example.be.mappers;

import com.example.be.DTO.response.TestReponseDTO;
import com.example.be.database.entities.Test;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TestMapper {


    TestReponseDTO testToTestDTO(Test test);

    List<TestReponseDTO> testsToTestDTOs(List<Test> tests);
}
