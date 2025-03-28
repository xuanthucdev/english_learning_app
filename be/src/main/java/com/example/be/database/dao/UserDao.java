package com.example.be.database.dao;

import com.example.be.database.entity.User;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface UserDao extends CrudRepository<User, Integer> {
    Optional<User> findByEmail(String email);
}
