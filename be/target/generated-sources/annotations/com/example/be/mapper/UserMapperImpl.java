package com.example.be.mapper;

import com.example.be.DTO.GetUserInfo;
import com.example.be.database.entity.User;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2025-03-27T22:02:30+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 17.0.11 (Oracle Corporation)"
)
@Component
public class UserMapperImpl implements UserMapper {

    @Override
    public GetUserInfo entityToDto(User user) {
        if ( user == null ) {
            return null;
        }

        GetUserInfo getUserInfo = new GetUserInfo();

        getUserInfo.setId( user.getId() );
        getUserInfo.setEmail( user.getEmail() );

        return getUserInfo;
    }

    @Override
    public User dtoToEntity(GetUserInfo getUserInfoDto) {
        if ( getUserInfoDto == null ) {
            return null;
        }

        User user = new User();

        user.setId( getUserInfoDto.getId() );
        user.setEmail( getUserInfoDto.getEmail() );

        return user;
    }
}
