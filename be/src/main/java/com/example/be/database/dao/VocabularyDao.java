package com.example.be.database.dao;

import com.example.be.database.entities.Vocabulary;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface VocabularyDao extends CrudRepository<Vocabulary, Long> {
    List<Vocabulary> findByWordContainingIgnoreCase(String word);

}
