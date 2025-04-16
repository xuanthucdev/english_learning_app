package com.example.be.DTO.response;

import com.example.be.database.enums.TestType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
public class TestReponseDto {
    private Long id;
    private String title;
    private String description;
    private TestType testType;
    private int durationMinutes;
    private int questionCount;
    private boolean isFree;
    private LocalDateTime createdAt;
}
