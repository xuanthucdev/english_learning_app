package com.example.be.database.dao;

import com.example.be.database.entities.Question;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionDao extends CrudRepository<Question, Long> {
    List<Question> findByTestId(Long testId);
}