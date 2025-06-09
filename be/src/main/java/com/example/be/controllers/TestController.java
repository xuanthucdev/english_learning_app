package com.example.be.controllers;

import com.example.be.DTO.request.SubmitTestRequest;
import com.example.be.DTO.response.SubmitTestResponse;
import com.example.be.DTO.response.TestDetailResponse;
import com.example.be.DTO.response.TestReponseDto;
import com.example.be.database.entities.Test;
import com.example.be.database.enums.TestType;
import com.example.be.services.TestService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/tests")
public class TestController {

    private final TestService testService;


    @GetMapping("/fulltest")
    public ResponseEntity<List<TestReponseDto>> getFullTests() {
        List<TestReponseDto> fullTests = testService.getFullTestsDTO();
        return ResponseEntity.ok(fullTests);

    }
    @GetMapping("/aptitudetest")
    public ResponseEntity<List<TestReponseDto>> getAptitudeTests( ) {
        List<TestReponseDto> apTests = testService.getAPTestsDTO();
        return ResponseEntity.ok(apTests);
    }
    @GetMapping("/minitest")
    public ResponseEntity<List<TestReponseDto>> getMiniTests() {
        List<TestReponseDto> miniTests = testService.getMiniTestsDTO();
        return ResponseEntity.ok(miniTests);
    }

    @PostMapping("/import")
    public ResponseEntity<String> importTest(@RequestParam("file") MultipartFile file) {
        try {
            Test test = testService.importTestFromCsv(file);
            return ResponseEntity.ok("Imported test '" + test.getTitle() + "' with " + test.getQuestionCount() + " questions successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error importing file: " + e.getMessage());
        }
    }
    @GetMapping("/{testId}/export")
    public ResponseEntity<byte[]> exportTest(@PathVariable Long testId) {
        try {
            String csvContent = testService.exportTestToCsv(testId);
            byte[] csvBytes = csvContent.getBytes();

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType("text/csv"));
            headers.setContentDispositionFormData("attachment", "test_" + testId + ".csv");
            headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");

            return ResponseEntity.ok()
                    .headers(headers)
                    .body(csvBytes);
        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(("Error exporting test: " + e.getMessage()).getBytes());
        }
    }
    @GetMapping("/{testId}")
    public ResponseEntity<TestDetailResponse> getTestDetails(@PathVariable Long testId) {
        TestDetailResponse response = testService.getTestDetails(testId);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/{testId}/submit")
    public ResponseEntity<SubmitTestResponse> submitTest(@PathVariable Long testId,
                                                         @RequestBody SubmitTestRequest request) {
        SubmitTestResponse response = testService.submitTest(testId, request);
        return ResponseEntity.ok(response);
    }
}
