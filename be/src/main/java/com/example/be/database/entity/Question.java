package com.example.be.database.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "questions")
public class Question {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "test_id", nullable = false)
    private Test test;

    @Column(nullable = false)
    private int partNumber;

    @Column( columnDefinition = "TEXT")
    private String questionText;

    @Column()
    private String questionType; // LISTENING, READING

    private String audioUrl;
    private String imageUrl;

}
