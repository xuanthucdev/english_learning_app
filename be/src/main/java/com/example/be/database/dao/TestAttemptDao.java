package com.example.be.database.dao;

import com.example.be.database.entities.TestAttempt;
import org.springframework.data.repository.CrudRepository;

public interface TestAttemptDao  extends CrudRepository<TestAttempt, Long> {
}
