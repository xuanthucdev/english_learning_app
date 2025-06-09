package com.example.be.database.entities;


import com.example.be.database.enums.Level;
import com.example.be.database.enums.Role;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Entity
@Table(name= "users")
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    @ElementCollection(fetch = FetchType.EAGER)
    private Set<Role> roles;

    private String fullName;
    @Column(name = "avatar")
    private String avatar;

    @Column(name = "registration_date", updatable = false)
    @CreationTimestamp
    private LocalDateTime registrationDate;

    private boolean isPremium = false;
    @Column(name = "vip_expiration_date")
    private LocalDateTime vipExpirationDate;
    private int targetScore = 600;
    private String phone;

    @CreationTimestamp
    private LocalDateTime createdAt;

    @Enumerated(EnumType.STRING)
    private Level currentLevel = Level.BEGINNER;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TestAttempt> testAttempts = new ArrayList<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserVocabProgress> vocabProgresses = new ArrayList<>();

    public boolean isVipActive() {
        return isPremium && vipExpirationDate != null && vipExpirationDate.isAfter(LocalDateTime.now());
    }


}
