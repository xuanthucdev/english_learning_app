package com.example.be.services;


import com.example.be.DTO.response.UserLoginResponseDTO;
import com.example.be.DTO.response.UserProfileDTO;
import com.example.be.database.dao.UserDao;
import com.example.be.database.entities.File;
import com.example.be.database.entities.User;
import com.example.be.database.enums.AppError;
import com.example.be.exceptions.AppException;
import com.example.be.mappers.UserMapper;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class UserService {
    @Autowired
    private  UserDao userDao;
    @Autowired
    private  UserMapper userMapper;
    @Autowired FileService fileService;

    public UserLoginResponseDTO.UserInfo findUserByEmail(String email) {
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
    public UserProfileDTO getUserProfile(Long id) {
        User user = userDao.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + id));

        UserProfileDTO dto = new UserProfileDTO();
        dto.setFullName(user.getFullName());
        dto.setPhone(user.getPhone());
        dto.setEmail(user.getEmail());
        dto.setAvatar(user.getAvatar());
        return dto;
    }

    public UserProfileDTO updateUserProfile(Long id, UserProfileDTO profileDTO) {
        User user = userDao.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + id));

        user.setFullName(profileDTO.getFullName());
        user.setPhone(profileDTO.getPhone());
        user.setEmail(profileDTO.getEmail());
        user.setAvatar(profileDTO.getAvatar());

        User updatedUser = userDao.save(user);

        UserProfileDTO updatedDTO = new UserProfileDTO();
        updatedDTO.setFullName(updatedUser.getFullName());
        updatedDTO.setPhone(updatedUser.getPhone());
        updatedDTO.setEmail(updatedUser.getEmail());
        updatedDTO.setAvatar(updatedDTO.getAvatar());
        return updatedDTO;
    }
    public File uploadAvatar(Long id, MultipartFile file) {
        User user = userDao.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("User not found with id: " + id));

        File fileEntity = fileService.upload(file);
        user.setAvatar(fileEntity.getPath());
        userDao.save(user);
        return fileEntity;
    }




}
