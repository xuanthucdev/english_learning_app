package com.example.be.database.entities;


import com.example.be.database.enums.Difficulty;
import com.example.be.database.enums.Part;
import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Data
@Entity
@Table(name = "questions")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Question {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "test_id")
    @JsonBackReference
    private Test test;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Part part;

    @Column(columnDefinition = "TEXT")
    private String content;

    private String audioUrl;
    private String imageUrl;

    @Column(columnDefinition = "TEXT")
    private String explanation;

    @Enumerated(EnumType.STRING)
    private Difficulty difficulty = Difficulty.MEDIUM;

    @OneToMany(mappedBy = "question", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private List<Answer> answer = new ArrayList<>();

    @OneToMany(mappedBy = "question")
    private List<UserAnswer> userAnswer = new ArrayList<>();


}
