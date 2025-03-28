package com.example.be.database.entity;


import com.example.be.common.entity.SystemField;
import jakarta.persistence.*;
import lombok.Data;


import java.io.Serializable;

@Entity
@Data
@Table(name = "users")
public class User implements Serializable {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private boolean isVip;

    @Embedded
    private SystemField systemField;





}
