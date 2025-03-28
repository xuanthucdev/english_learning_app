package com.example.be.DTO;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class LoginReponseBody implements Serializable {
    /** UID */
    @Serial
    private static final long serialVersionUID = 1L;

    private String token;
    private GetUserInfo user;
}
