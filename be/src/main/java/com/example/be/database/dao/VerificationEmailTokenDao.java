package com.example.be.database.dao;


import com.example.be.database.entities.User;
import com.example.be.database.entities.VerificationEmailToken;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface VerificationEmailTokenDao extends CrudRepository<VerificationEmailToken, Long> {
    Optional<VerificationEmailToken> findByToken(String token);
    void deleteAllByUser(User user);
}
