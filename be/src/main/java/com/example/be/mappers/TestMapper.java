package com.example.be.mappers;

import com.example.be.DTO.response.TestReponseDto;
import com.example.be.database.entities.Test;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TestMapper {


    TestReponseDto testToTestDTO(Test test);

    List<TestReponseDto> testsToTestDTOs(List<Test> tests);
}
