package com.example.be.database.entities;

import jakarta.persistence.*;

import java.io.Serializable;
import java.time.LocalDate;
@Entity
@Table(name = "user_vocab_progress")
public class UserVocabProgress {
    @EmbeddedId
    private UserVocabProgressId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("vocabularyId")
    @JoinColumn(name = "vocabulary_id")
    private Vocabulary  vocabulary;

    @Column(name = "mastery_level")
    private int masteryLevel = 1;

    @Column(name = "last_reviewed")
    private LocalDate lastReviewed;

    @Column(name = "next_review_date")
    private LocalDate nextReviewDate;
    @Embeddable
    public static class UserVocabProgressId implements Serializable {
        private Long userId;
        private Long vocabularyId;

        // Constructors, equals, hashCode
    }
}
