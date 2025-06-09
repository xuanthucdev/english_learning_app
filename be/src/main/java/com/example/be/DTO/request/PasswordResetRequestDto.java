package com.example.be.DTO.request;
import jakarta.validation.constraints.NotBlank;
import lombok.*;

@Data
public class PasswordResetRequestDto {
    @NotBlank(message = "Token is required")
    private String token;

    @NotBlank(message = "New password is required")
    private String newPassword;
}
