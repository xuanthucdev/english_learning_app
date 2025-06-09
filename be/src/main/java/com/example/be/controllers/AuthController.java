    package com.example.be.controllers;


    import com.example.be.DTO.request.PasswordResetRequestDto;
    import com.example.be.DTO.request.UserLoginRequestDto;
    import com.example.be.DTO.request.UserSignUpRequest;
    import com.example.be.DTO.response.UserLoginResponseDto;
    import com.example.be.database.entities.User;
    import com.example.be.database.enums.AppError;
    import com.example.be.exceptions.AppException;
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
                @RequestBody @Valid UserLoginRequestDto userLoginRequestDto) {
            return ResponseEntity.ok(authService.login(userLoginRequestDto));
        }

        @Operation(
                summary = "User Sign Up",
                description = "Registers a new user, sends an email with a verification link, and returns the created user's information."
        )
        @PostMapping("/signup")
        public ResponseEntity<UserLoginResponseDto.UserInfo> signup(
                @RequestBody @Valid UserSignUpRequest userSignUpRequest) {
            UserLoginResponseDto.UserInfo user = authService.signUp(userSignUpRequest);
            String verificationUrl = "http://localhost:8083/auth/verify?token="
                    + authService.createVerificationToken(user.getId());
            emailService.sendSimpleMessage(userSignUpRequest.getEmail(), "Verify account",
                    "Please click the link to verify your account: " + verificationUrl);
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
            authService.requestPasswordReset(email);
            User user = authService.userDao.findByEmail(email)
                    .orElseThrow(() -> new AppException(AppError.USER_NOT_FOUND));
            String resetUrl = "http://localhost:8083/auth/password/reset?token="
                    + authService.createPasswordResetToken(user.getId());
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
                @RequestBody @Valid PasswordResetRequestDto passwordResetRequestDto) {
            authService.resetPassword(passwordResetRequestDto);
            return ResponseEntity.ok().build();
        }



    }
