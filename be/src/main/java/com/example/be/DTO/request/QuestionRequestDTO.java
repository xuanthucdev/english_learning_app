package com.example.be.DTO.request;

import com.example.be.database.enums.Difficulty;
import com.example.be.database.enums.Part;
import lombok.Data;

import java.util.List;

@Data
public class QuestionRequestDTO {
    private Long testId;
    private Part part;
    private String content;
    private String audioUrl;
    private String imageUrl;
    private String explanation;
    private Difficulty difficulty;
    private List<AnswerDTO> answers;

    @Data
    public static class AnswerDTO {
        private String content;
        private boolean isCorrect;
        private Integer answerOrder;
    }
}