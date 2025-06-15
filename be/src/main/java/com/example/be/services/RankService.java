package com.example.be.services;

import com.example.be.DTO.response.RankUserDTO;
import com.example.be.database.dao.TestAttemptDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RankService {

    @Autowired
    private TestAttemptDao testAttemptDao;

    public List<RankUserDTO> getTop10RankedUsers() {
        List<Object[]> rawResult = testAttemptDao.findTop10RankedUsers();

        List<RankUserDTO> result = new ArrayList<>();
        for (Object[] row : rawResult) {
            int rank = ((Number) row[0]).intValue();
            String userName = (String) row[1];
            int score = ((Number) row[2]).intValue();
            Long testId = ((Number) row[3]).longValue();

            result.add(new RankUserDTO(rank, userName, score, testId));
        }

        return result;
    }
}