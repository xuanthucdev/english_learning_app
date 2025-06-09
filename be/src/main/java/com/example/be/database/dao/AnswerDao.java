package com.example.be.database.dao;

import com.example.be.database.entities.Answer;
import org.springframework.data.repository.CrudRepository;

public interface AnswerDao extends CrudRepository<Answer, Integer> {
}
