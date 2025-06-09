package com.example.be.services;


import com.example.be.DTO.request.PasswordResetRequestDto;
import com.example.be.DTO.request.UserLoginRequestDto;
import com.example.be.DTO.request.UserSignUpRequest;
import com.example.be.DTO.response.UserLoginResponseDto;
import com.example.be.database.dao.UserDao;
import com.example.be.database.dao.VerificationEmailTokenDao;
import com.example.be.database.entities.User;
import com.example.be.database.entities.VerificationEmailToken;
import com.example.be.database.enums.AppError;
import com.example.be.database.enums.TokenType;
import com.example.be.exceptions.AppException;
import com.example.be.mappers.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserMapper userMapper;
    public final UserDao userDao;
    private final PasswordEncoder passwordEncoder;
    private final VerificationEmailTokenDao verificationEmailTokenDao;
    private final JwtTokenProvider jwtTokenProvider;

    public UserLoginResponseDto login(UserLoginRequestDto userLoginRequestDto) {
        User user = userDao.findByEmail(userLoginRequestDto.getEmail()).orElseThrow(() -> new AppException(AppError.AUTH_INVALID_CREDENTIALS));
        if (!passwordEncoder.matches(userLoginRequestDto.getPassword(), user.getPassword())) {
            throw new AppException(AppError.AUTH_INVALID_CREDENTIALS);
        }
        UserLoginResponseDto.UserInfo userInfo = userMapper.entityToDto(user);
        return UserLoginResponseDto.builder().user(userInfo).accessToken(jwtTokenProvider.generateToken(userInfo.getEmail())).build();
    }


    @Transactional
    public UserLoginResponseDto.UserInfo signUp(UserSignUpRequest dto) {
        User existUser = userDao.findByEmail(dto.getEmail()).orElse(null);
        if (existUser != null ) {
            throw new AppException(AppError.USER_EMAIL_ALREADY_EXISTS);
        } else if (existUser != null) {
            return userMapper.entityToDto(existUser);
        }
        if (StringUtils.hasText(dto.getPhone()) && userDao.existsByPhone(dto.getPhone()))
            throw new AppException(AppError.USER_PHONE_ALREADY_EXISTS);

        dto.setPassword(passwordEncoder.encode(dto.getPassword()));
        User user = userMapper.dtoToEntity(dto);
        return userMapper.entityToDto(userDao.save(user));
    }

    @Transactional
    public String createVerificationToken(Long userId) {
        String token = UUID.randomUUID().toString();
        verificationEmailTokenDao.save(VerificationEmailToken.builder().token(token).user(userDao.findById(userId).orElseThrow(() -> new AppException(AppError.USER_NOT_FOUND))).build());
        return token;
    }
    // Tạo token đặt lại mật khẩu
    @Transactional
    public String createPasswordResetToken(Long userId) {
        User user = userDao.findById(userId)
                .orElseThrow(() -> new AppException(AppError.USER_NOT_FOUND));
        String token = UUID.randomUUID().toString();
        VerificationEmailToken resetToken = VerificationEmailToken.builder()
                .token(token)
                .user(user)
                .tokenType(TokenType.PASSWORD_RESET)
                .expiryDate(LocalDateTime.now().plusHours(24))
                .build();
        verificationEmailTokenDao.save(resetToken);
        return token;
    }

    // Yêu cầu đặt lại mật khẩu
    @Transactional
    public void requestPasswordReset(String email) {
        User user = userDao.findByEmail(email)
                .orElseThrow(() -> new AppException(AppError.USER_NOT_FOUND));
        // Kiểm tra Premium (tùy chọn)
        if (!user.isVipActive()) {
            // Có thể thêm logic giới hạn, ví dụ: số lần yêu cầu tối đa
        }
        createPasswordResetToken(user.getId());
    }

    // Đặt lại mật khẩu
    @Transactional
    public void resetPassword(PasswordResetRequestDto dto) {
    VerificationEmailToken token = verificationEmailTokenDao.findByTokenAndTokenType(dto.getToken(), TokenType.PASSWORD_RESET)
            .orElseThrow(() -> new AppException(AppError.TOKEN_INVALID));
        if (token.getExpiryDate().isBefore(LocalDateTime.now())) {
        throw new AppException(AppError.TOKEN_EXPIRED);
    }

    User user = token.getUser();
        user.setPassword(passwordEncoder.encode(dto.getNewPassword()));
        userDao.save(user);

    // Xóa token sau khi sử dụng
        verificationEmailTokenDao.delete(token);
}

}
