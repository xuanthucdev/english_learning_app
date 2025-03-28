package com.example.be.mapper;

import com.example.be.DTO.GetUserInfo;
import com.example.be.database.entity.User;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {

    GetUserInfo entityToDto(User user);

    User dtoToEntity(GetUserInfo getUserInfoDto);
}
