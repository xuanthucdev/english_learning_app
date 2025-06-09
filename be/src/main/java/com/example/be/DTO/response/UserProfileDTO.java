package com.example.be.DTO.response;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class UserProfileDTO {
    @NotBlank
    private String email;


    @NotBlank(message = "Full name cannot be empty")
    @Size(max = 100, message = "Full name must not exceed 100 characters")
    private String fullName;

    @Size(max = 15, message = "Phone number must not exceed 15 characters")
    private String phone;

    @Size(max = 255, message = "Avatar URL must not exceed 255 characters")
    @Pattern(regexp = "^(https?://.*\\.(?:png|jpg|jpeg|gif)|)$", message = "Invalid avatar URL")
    private String avatar;


}
