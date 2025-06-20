package com.example.be.controllers;

import com.example.be.DTO.response.RankUserDTO;
import com.example.be.services.RankService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/rank")
public class RankController {

    @Autowired
    private RankService rankService;

    @GetMapping("/top10")
    public ResponseEntity<List<RankUserDTO>> getTop10() {
        return ResponseEntity.ok(rankService.getTop10RankedUsers());
    }
}