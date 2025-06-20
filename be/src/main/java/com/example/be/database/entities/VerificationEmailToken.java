package com.example.be.database.entities;

import com.example.be.database.enums.TokenType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "verification_email_tokens")
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class VerificationEmailToken {
    private static final int EXPIRATION_MINUTES = 60 * 24; // 24 giờ

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String token;

    @ManyToOne
    @JoinColumn(nullable = false)
    private User user;

    private LocalDateTime expiryDate;

    @PrePersist
    protected void onCreate() {
        if (expiryDate == null) {
            expiryDate = LocalDateTime.now().plusMinutes(EXPIRATION_MINUTES);
        }
    }
    @Enumerated(EnumType.STRING)
    private TokenType tokenType;
}
