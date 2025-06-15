package com.example.be.mappers;


import com.example.be.DTO.response.FileResponseDTO;
import com.example.be.database.entities.File;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface FileMapper {
    FileResponseDTO entityToDto(File file);
}
