package com.example.be.database.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "answers")
public class Answer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "question_id", nullable = false)
    private Question question;

    @Column( columnDefinition = "TEXT")
    private String answerText;

    @Column(nullable = false)
    private boolean isCorrect;


}