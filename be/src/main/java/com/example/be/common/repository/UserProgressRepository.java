package com.example.be.common.repository;

import com.example.be.database.entity.UserProgress;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserProgressRepository  extends JpaRepository<UserProgress,Long> {
    List<UserProgress> findByUserId(Long userId);
}
