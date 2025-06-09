package com.example.be.DTO.response;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class TestDetailResponse {
    private Long id;
    private String title;
    private String description;
    private String testType;
    private int durationMinutes;
    private int questionCount;
    private boolean isFree;
    private List<QuestionDTO> questions;

    @Data
    @Builder
    public static class QuestionDTO {
        private Long id;
        private String part;
        private String content;
        private String audioUrl;
        private String imageUrl;
        private String difficulty;
        private List<AnswerDTO> answers;
    }

    @Data
    @Builder
    public static class AnswerDTO {
        private Long id;
        private String content;
        private Integer answerOrder;
    }
}
