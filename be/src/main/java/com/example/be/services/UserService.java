package com.example.be.services;


import com.example.be.DTO.response.UserLoginResponseDto;
import com.example.be.database.dao.UserDao;
import com.example.be.database.entities.User;
import com.example.be.database.enums.AppError;
import com.example.be.exceptions.AppException;
import com.example.be.mappers.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserDao userDao;
    private final UserMapper userMapper;

    public UserLoginResponseDto.UserInfo findUserByEmail(String email) {
        return userMapper.entityToDto(userDao.findByEmail(email).orElseThrow(() -> new AppException(AppError.USER_NOT_FOUND)));
    }
    public void upgradeToVip(Long userId, int days) {
        User user = userDao.findById(userId)
                .orElseThrow(() -> new AppException(AppError.USER_NOT_FOUND));


        if (user.isPremium() && user.getVipExpirationDate() != null
                && user.getVipExpirationDate().isAfter(LocalDateTime.now())) {
            throw new AppException(AppError.ALREADY_VIP);
        }


        user.setPremium(true);
        user.setVipExpirationDate(LocalDateTime.now().plusDays(days));

        userDao.save(user);
    }





}
