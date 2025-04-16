package com.example.be.database.entities;


import com.example.be.database.enums.Difficulty;
import com.example.be.database.enums.Part;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name="questions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Question {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "test_id")
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
    private List<Answer> answer = new ArrayList<>();

    @OneToMany(mappedBy = "question")
    private List<UserAnswer> userAnswer = new ArrayList<>();
}
