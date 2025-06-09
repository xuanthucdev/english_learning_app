package com.example.be.mappers;


import com.example.be.DTO.response.FileResponseDto;
import com.example.be.database.entities.File;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface FileMapper {
    FileResponseDto entityToDto(File file);
}
