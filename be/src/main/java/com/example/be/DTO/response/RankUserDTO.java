package com.example.be.DTO.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Builder
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class RankUserDTO {
    private int rank;
    private String userName;
    private int score;
    private Long testId;
}
