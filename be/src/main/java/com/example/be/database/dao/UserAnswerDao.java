package com.example.be.database.dao;

import com.example.be.database.entities.UserAnswer;
import org.springframework.data.repository.CrudRepository;

public interface UserAnswerDao extends CrudRepository<UserAnswer, Long> {
}
