package com.example.be.database.dao;

import com.example.be.DTO.response.TestReponseDto;
import com.example.be.database.enums.TestType;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import com.example.be.database.entities.Test;

import java.util.List;
import java.util.Optional;

@Repository
public interface TestDao extends CrudRepository<Test, Long> {
    List<Test> findByTestType(TestType testType);


}
