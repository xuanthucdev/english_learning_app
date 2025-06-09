package com.example.be.database.entities;

import com.example.be.database.enums.Difficulty;
import com.example.be.database.enums.ToeicFrequency;
import com.example.be.database.enums.Topic;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "vocabularies")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Vocabulary {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String word;

    @Column(columnDefinition = "TEXT", nullable = false)
    private String definition;

    @Column(columnDefinition = "TEXT")
    private String example;

    @Enumerated(EnumType.STRING)
    private Topic topic = Topic.BUSINESS;

    @Enumerated(EnumType.STRING)
    private Difficulty difficulty = Difficulty.MEDIUM;

    @Enumerated(EnumType.STRING)
    @Column(name = "toeic_frequency")
    private ToeicFrequency toeicFrequency;

    @OneToMany(mappedBy = "vocabulary", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserVocabProgress> userProgresses = new ArrayList<>();




}