    package com.example.be.controllers;


    import com.example.be.DTO.request.PasswordResetRequestDTO;
    import com.example.be.DTO.request.UserLoginRequestDTO;
    import com.example.be.DTO.request.UserSignUpRequestDTO;
    import com.example.be.DTO.response.UserLoginResponseDTO;
    import com.example.be.database.entities.User;
    import com.example.be.services.AuthService;
    import com.example.be.services.EmailService;
    import io.swagger.v3.oas.annotations.Operation;
    import io.swagger.v3.oas.annotations.Parameter;
    import io.swagger.v3.oas.annotations.tags.Tag;
    import jakarta.validation.Valid;
    import lombok.RequiredArgsConstructor;
    import org.springframework.http.ResponseEntity;
    import org.springframework.web.bind.annotation.*;
    import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

    import java.net.URI;

    @RestController
    @RequiredArgsConstructor
    @RequestMapping("/auth")
    @Tag(name = "Auth API", description = "APIs for user authentication, account registration, and email verification")
    public class AuthController {

        private final AuthService authService;
        private final EmailService emailService;

        @Operation(
                summary = "User Login",
                description = "Authenticates a user with the provided credentials and returns a login response (e.g., token, user info)."
        )
        @PostMapping("/login")
        public ResponseEntity<?> login(
                @RequestBody @Valid UserLoginRequestDTO userLoginRequestDto) {
            return ResponseEntity.ok(authService.login(userLoginRequestDto));
        }

        @Operation(
                summary = "User Sign Up",
                description = "Registers a new user, sends an email with a verification link, and returns the created user's information."
        )
        @PostMapping("/signup")
        public ResponseEntity<UserLoginResponseDTO.UserInfo> signup(
                @RequestBody @Valid UserSignUpRequestDTO userSignUpRequest) {
            UserLoginResponseDTO.UserInfo user = authService.signUp(userSignUpRequest);

            URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                    .path("/{id}")
                    .buildAndExpand(user.getId())
                    .toUri();
            return ResponseEntity.created(location).body(user);
        }
        // Yêu cầu đặt lại mật khẩu
        @Operation(
                summary = "Request Password Reset",
                description = "Sends a password reset link to the user's email if the email exists."
        )
        @PostMapping("/password/reset")
        public ResponseEntity<?> requestPasswordReset(
                @RequestParam @Parameter(description = "User's email address") String email) {
            // Call requestPasswordReset to validate the email and user existence
            authService.requestPasswordReset(email);

            // Since requestPasswordReset already verifies the user exists, we can create the token
            User user = authService.getUserByEmail(email); // Add this method to AuthService (see below)
            String resetUrl = "http://localhost:8083/auth/password/reset?token="
                    + authService.createPasswordResetToken(user.getId());

            // Send the reset email
            emailService.sendSimpleMessage(email, "Reset Your Password",
                    "Please click the link to reset your password: " + resetUrl);

            return ResponseEntity.ok().build();
        }

        // Đặt lại mật khẩu
        @Operation(
                summary = "Reset Password",
                description = "Resets the user's password using a valid reset token."
        )
        @PostMapping("/password/reset/confirm")
        public ResponseEntity<?> resetPassword(
                @RequestBody @Valid PasswordResetRequestDTO passwordResetRequestDto) {
            authService.resetPassword(passwordResetRequestDto);
            return ResponseEntity.ok().build();
        }



    }
