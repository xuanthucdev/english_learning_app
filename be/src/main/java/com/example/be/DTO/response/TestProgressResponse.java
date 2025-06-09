package com.example.be.DTO.response;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class TestProgressResponse {
    private Long userId;
    private int totalTestsTaken;
    private double averageScore;
    private List<TestAttemptSummary> testAttempts;

    @Data
    @Builder
    public static class TestAttemptSummary {
        private Long testId;
        private String testTitle;
        private int score;
        private int totalQuestions;
        private LocalDateTime completedAt;
    }
}
