package com.example.be.database.dao;

import com.example.be.database.entities.TestAttempt;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface TestAttemptDao  extends CrudRepository<TestAttempt, Long> {
    @Query(value = """
        SELECT RANK() OVER (ORDER BY ta.score DESC) AS rank,
               u.full_name AS userName,
               ta.score,
               ta.test_id AS testId
        FROM test_attempts ta
        JOIN "users" u ON ta.user_id = u.id
        ORDER BY ta.score DESC
        LIMIT 10
        """, nativeQuery = true)
    List<Object[]> findTop10RankedUsers();
}
