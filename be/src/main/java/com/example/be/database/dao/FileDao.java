package com.example.be.database.dao;


import com.example.be.database.entities.File;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FileDao extends CrudRepository<File, Long> {
}
