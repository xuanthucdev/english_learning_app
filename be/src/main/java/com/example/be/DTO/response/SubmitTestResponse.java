package com.example.be.DTO.response;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SubmitTestResponse {
    private Long testId;
    private Long userId;
    private int score;
    private int totalQuestions;
}
