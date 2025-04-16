package com.example.be.mappers;

import com.example.be.DTO.request.UserSignUpRequest;
import com.example.be.DTO.response.UserLoginResponseDto;
import com.example.be.database.entities.User;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {
    User dtoToEntity(UserSignUpRequest dto);
    UserLoginResponseDto.UserInfo entityToDto(User user);

}
