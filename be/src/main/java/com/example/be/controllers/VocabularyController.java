package com.example.be.controllers;

import com.example.be.database.dao.VocabularyDao;
import com.example.be.database.entities.Vocabulary;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/vocabularies")
public class VocabularyController {
    @Autowired
    private VocabularyDao vocabularyDao;

    @GetMapping
    public List<Vocabulary> getAll() {
        List<Vocabulary> vocabList = new ArrayList<>();
        vocabularyDao.findAll().forEach(vocabList::add);
        return vocabList;
    }

    @GetMapping("/{id}")
    public ResponseEntity<Vocabulary> getById(@PathVariable Long id) {
        return vocabularyDao.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Vocabulary create(@RequestBody Vocabulary vocabulary) {
        return vocabularyDao.save(vocabulary);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Vocabulary> update(@PathVariable Long id, @RequestBody Vocabulary updated) {
        return vocabularyDao.findById(id).map(existing -> {
            existing.setWord(updated.getWord());
            existing.setDefinition(updated.getDefinition());
            existing.setExample(updated.getExample());
            existing.setTopic(updated.getTopic());
            existing.setDifficulty(updated.getDifficulty());
            existing.setToeicFrequency(updated.getToeicFrequency());
            return ResponseEntity.ok(vocabularyDao.save(existing));
        }).orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (vocabularyDao.existsById(id)) {
            vocabularyDao.deleteById(id);
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.notFound().build();
    }

    @GetMapping("/search")
    public List<Vocabulary> search(@RequestParam String word) {
        return vocabularyDao.findByWordContainingIgnoreCase(word);
    }
    @PostMapping("/batch")
    public List<Vocabulary> createBatch(@RequestBody List<Vocabulary> vocabularies) {
        return (List<Vocabulary>) vocabularyDao.saveAll(vocabularies);
    }
}
