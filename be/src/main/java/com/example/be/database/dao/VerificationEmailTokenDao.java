package com.example.be.database.dao;


import com.example.be.database.entities.User;
import com.example.be.database.entities.VerificationEmailToken;
import com.example.be.database.enums.TokenType;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface VerificationEmailTokenDao extends CrudRepository<VerificationEmailToken, Long> {
    Optional<VerificationEmailToken> findByTokenAndTokenType(String token, TokenType tokenType);
}
