package com.example.be.mappers;

import com.example.be.DTO.request.UserSignUpRequestDTO;
import com.example.be.DTO.response.UserLoginResponseDTO;
import com.example.be.database.entities.User;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {
    User dtoToEntity(UserSignUpRequestDTO dto);
    UserLoginResponseDTO.UserInfo entityToDto(User user);

}
