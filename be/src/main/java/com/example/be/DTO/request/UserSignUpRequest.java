package com.example.be.DTO.request;


import jakarta.validation.constraints.*;
import lombok.*;



@Builder
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class UserSignUpRequest {
    private String fullName;


    @NotBlank(message = "Email must not be blank")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Password must not be blank")
    @Size(min = 6, message = "Password must be greater than 6")
    private String password;
    @Pattern(regexp = "(03|05|07|08|09|01[2|6|8|9])+([0-9]{8})\\b", message = "Invalid phone number format")
    private String phone;
}
