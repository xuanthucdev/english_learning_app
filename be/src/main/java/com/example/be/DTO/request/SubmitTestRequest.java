package com.example.be.DTO.request;

import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class SubmitTestRequest {
    private Long userId;
    private List<UserAnswerDTO> answers;
    private LocalDateTime startTime;

    @Data
    public class UserAnswerDTO {
        private Long questionId;
        private Long answerId;
    }
}
