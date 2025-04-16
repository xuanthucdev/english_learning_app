package com.example.be.database.dao;

import com.example.be.database.enums.TestType;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import com.example.be.database.entities.Test;

import java.util.List;

@Repository
public interface TestDao extends CrudRepository<Test, Long> {
    List<Test> findByTestType(TestType testType);

}
