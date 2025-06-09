package com.example.be.services;

import com.example.be.DTO.request.SubmitTestRequest;
import com.example.be.DTO.response.SubmitTestResponse;
import com.example.be.DTO.response.TestCSVDTO;
import com.example.be.DTO.response.TestDetailResponse;
import com.example.be.DTO.response.TestReponseDto;
import com.example.be.database.dao.TestAttemptDao;
import com.example.be.database.dao.TestDao;
import com.example.be.database.dao.UserAnswerDao;
import com.example.be.database.dao.UserDao;
import com.example.be.database.entities.*;
import com.example.be.database.enums.Difficulty;
import com.example.be.database.enums.Part;
import com.example.be.database.enums.TestType;
import com.example.be.mappers.TestMapper;
import com.opencsv.bean.CsvToBeanBuilder;
import com.opencsv.bean.StatefulBeanToCsv;
import com.opencsv.bean.StatefulBeanToCsvBuilder;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.StringWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TestService {

    @Autowired
    private  TestDao testDao;
    @Autowired
    private  TestMapper testMapper;
    @Autowired
    private TestAttemptDao testAttemptDao;
    @Autowired
    private UserAnswerDao  userAnswerDao;
    @Autowired
    private UserDao userDao;


    public List<TestReponseDto> getFullTestsDTO() {
        List<Test> tests = testDao.findByTestType(TestType.FULL_TEST);
        return testMapper.testsToTestDTOs(tests);
    }

    public List<TestReponseDto> getAPTestsDTO() {
        List<Test> tests = testDao.findByTestType(TestType.APTITUDE_TEST);
        return testMapper.testsToTestDTOs(tests);
    }

    public List<TestReponseDto> getMiniTestsDTO() {
        List<Test> tests = testDao.findByTestType(TestType.MINI_TEST);
        return testMapper.testsToTestDTOs(tests);
    }

    public Test getTestById(Long id) {
        return testDao.findById(id)
                .orElseThrow(() -> new RuntimeException("Test not found with id: " + id));
    }

    public Test importTestFromCsv(MultipartFile file) throws Exception {
        // Đọc file CSV
        try (Reader reader = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
            // Ánh xạ file CSV thành danh sách TestCSVDTO
            List<TestCSVDTO> csvRecords = new CsvToBeanBuilder<TestCSVDTO>(reader)
                    .withType(TestCSVDTO.class)
                    .build()
                    .parse();

            // Nhóm các bản ghi theo test_title để tạo một Test duy nhất
            Map<String, List<TestCSVDTO>> groupedByTest = csvRecords.stream()
                    .collect(Collectors.groupingBy(TestCSVDTO::getTestTitle));

            if (groupedByTest.size() > 1) {
                throw new IllegalArgumentException("CSV contains multiple tests. Only one test per CSV is supported.");
            }

            // Lấy test đầu tiên (giả định CSV chỉ chứa một bài thi)
            List<TestCSVDTO> testRecords = groupedByTest.values().iterator().next();
            TestCSVDTO firstRecord = testRecords.get(0);

            // Tạo Test entity
            Test test = new Test();
            test.setTitle(firstRecord.getTestTitle());
            test.setDescription(firstRecord.getTestDescription());
            test.setTestType(TestType.valueOf(firstRecord.getTestType()));
            test.setDurationMinutes(firstRecord.getDurationMinutes());
            test.setFree(firstRecord.isFree());
            test.setQuestionCount(testRecords.size());

            // Tạo danh sách Question và Answer
            List<Question> questions = new ArrayList<>();
            for (TestCSVDTO record : testRecords) {
                // Tạo Question
                Question question = new Question();
                question.setTest(test);
                question.setPart(Part.valueOf(record.getQuestionPart()));
                question.setContent(record.getQuestionContent());
                question.setAudioUrl(record.getQuestionAudioUrl());
                question.setImageUrl(record.getQuestionImageUrl());
                question.setExplanation(record.getQuestionExplanation());
                question.setDifficulty(Difficulty.valueOf(record.getQuestionDifficulty()));

                // Tạo danh sách Answer
                List<Answer> answers = new ArrayList<>();
                for (int i = 1; i <= 4; i++) {
                    String content = switch (i) {
                        case 1 -> record.getAnswerContent1();
                        case 2 -> record.getAnswerContent2();
                        case 3 -> record.getAnswerContent3();
                        case 4 -> record.getAnswerContent4();
                        default -> null;
                    };
                    boolean isCorrect = switch (i) {
                        case 1 -> record.isCorrect1();
                        case 2 -> record.isCorrect2();
                        case 3 -> record.isCorrect3();
                        case 4 -> record.isCorrect4();
                        default -> false;
                    };
                    int answerOrder = switch (i) {
                        case 1 -> record.getAnswerOrder1();
                        case 2 -> record.getAnswerOrder2();
                        case 3 -> record.getAnswerOrder3();
                        case 4 -> record.getAnswerOrder4();
                        default -> 0;
                    };

                    if (content != null && !content.isEmpty()) {
                        Answer answer = new Answer();
                        answer.setQuestion(question);
                        answer.setContent(content);
                        answer.setCorrect(isCorrect);
                        answer.setAnswerOrder(answerOrder);
                        answers.add(answer);
                    }
                }
                question.setAnswer(answers);
                questions.add(question);
            }
            test.setQuestions(questions);

            // Lưu Test vào database
            return testDao.save(test);
        }

    }
    public String exportTestToCsv(Long testId) throws Exception {
        Test test = testDao.findById(testId)
                .orElseThrow(() -> new IllegalArgumentException("Test with ID " + testId + " not found"));

        List<TestCSVDTO> csvRecords = new ArrayList<>();
        for (Question question : test.getQuestions()) {
            TestCSVDTO dto = new TestCSVDTO();
            dto.setTestTitle(test.getTitle());
            dto.setTestDescription(test.getDescription());
            dto.setTestType(test.getTestType().name());
            dto.setDurationMinutes(test.getDurationMinutes());
            dto.setFree(test.isFree());
            dto.setQuestionPart(question.getPart().name());
            dto.setQuestionContent(question.getContent());
            dto.setQuestionAudioUrl(question.getAudioUrl() != null ? question.getAudioUrl() : "");
            dto.setQuestionImageUrl(question.getImageUrl() != null ? question.getImageUrl() : "");
            dto.setQuestionExplanation(question.getExplanation() != null ? question.getExplanation() : "");
            dto.setQuestionDifficulty(question.getDifficulty().name());

            // Ánh xạ các đáp án (giả định tối đa 4 đáp án)
            List<Answer> answers = question.getAnswer();
            for (int i = 0; i < Math.min(answers.size(), 4); i++) {
                Answer answer = answers.get(i);
                switch (i) {
                    case 0 -> {
                        dto.setAnswerContent1(answer.getContent());
                        dto.setCorrect1(answer.isCorrect());
                        dto.setAnswerOrder1(answer.getAnswerOrder());
                    }
                    case 1 -> {
                        dto.setAnswerContent2(answer.getContent());
                        dto.setCorrect2(answer.isCorrect());
                        dto.setAnswerOrder2(answer.getAnswerOrder());
                    }
                    case 2 -> {
                        dto.setAnswerContent3(answer.getContent());
                        dto.setCorrect3(answer.isCorrect());
                        dto.setAnswerOrder3(answer.getAnswerOrder());
                    }
                    case 3 -> {
                        dto.setAnswerContent4(answer.getContent());
                        dto.setCorrect4(answer.isCorrect());
                        dto.setAnswerOrder4(answer.getAnswerOrder());
                    }
                }
            }
            csvRecords.add(dto);
        }

        // Chuyển danh sách TestCSVDTO thành CSV
        StringWriter writer = new StringWriter();
        StatefulBeanToCsv<TestCSVDTO> beanToCsv = new StatefulBeanToCsvBuilder<TestCSVDTO>(writer)
                .withQuotechar('"')
                .build();
        beanToCsv.write(csvRecords);
        return writer.toString();
    }
    public TestDetailResponse getTestDetails(Long testId) {
        Test test = testDao.findById(testId)
                .orElseThrow(() -> new RuntimeException("Test not found"));

        return TestDetailResponse.builder()
                .id(test.getId())
                .title(test.getTitle())
                .description(test.getDescription())
                .testType(test.getTestType().name())
                .durationMinutes(test.getDurationMinutes())
                .questionCount(test.getQuestionCount())
                .isFree(test.isFree())
                .questions(test.getQuestions().stream().map(q -> TestDetailResponse.QuestionDTO.builder()
                                .id(q.getId())
                                .part(q.getPart().name())
                                .content(q.getContent())
                                .audioUrl(q.getAudioUrl())
                                .imageUrl(q.getImageUrl())
                                .difficulty(q.getDifficulty().name())
                                .answers(q.getAnswer().stream().map(a -> TestDetailResponse.AnswerDTO.builder()
                                                .id(a.getId())
                                                .content(a.getContent())
                                                .answerOrder(a.getAnswerOrder())
                                                .build())
                                        .collect(Collectors.toList()))
                                .build())
                        .collect(Collectors.toList()))
                .build();
    }
    @Transactional
    public SubmitTestResponse submitTest(Long testId, SubmitTestRequest request) {
        // 1. Validate user và test
        User user = userDao.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("User not found"));

        Test test = testDao.findById(testId)
                .orElseThrow(() -> new RuntimeException("Test not found"));



        // 3. Kiểm tra thời gian làm bài
        if (request.getStartTime() == null) {
            throw new RuntimeException("Start time is required");
        }

        if (request.getStartTime().plusMinutes(test.getDurationMinutes()).isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Test duration exceeded");
        }

        // 4. Kiểm tra danh sách câu trả lời
        if (request.getAnswers() == null || request.getAnswers().isEmpty()) {
            throw new RuntimeException("No answers submitted");
        }

        // 5. Tạo đối tượng TestAttempt
        TestAttempt testAttempt = new TestAttempt();
        testAttempt.setTest(test);
        testAttempt.setUser(user);
        testAttempt.setStartTime(request.getStartTime());
        testAttempt.setEndTime(LocalDateTime.now());

        // 6. Chuẩn bị map để tra cứu nhanh câu hỏi
        Map<Long, Question> questionMap = test.getQuestions()
                .stream()
                .collect(Collectors.toMap(Question::getId, q -> q));

        int correctAnswers = 0;
        int totalQuestions = test.getQuestions().size();

        for (SubmitTestRequest.UserAnswerDTO userAnswerDTO : request.getAnswers()) {
            Question question = questionMap.get(userAnswerDTO.getQuestionId());
            if (question == null) {
                throw new RuntimeException("Question not found with ID: " + userAnswerDTO.getQuestionId());
            }

            // Tìm đáp án được chọn
            Optional<Answer> selectedAnswerOpt = question.getAnswer()
                    .stream()
                    .filter(a -> a.getId().equals(userAnswerDTO.getAnswerId()))
                    .findFirst();

            if (selectedAnswerOpt.isEmpty()) {
                throw new RuntimeException("Answer not found for question ID: " + userAnswerDTO.getQuestionId());
            }

            Answer selectedAnswer = selectedAnswerOpt.get();

            // Lưu UserAnswer
            UserAnswer userAnswer = new UserAnswer();
            userAnswer.setTestAttempt(testAttempt);
            userAnswer.setQuestion(question);
            userAnswer.setAnswer(selectedAnswer);
            userAnswerDao.save(userAnswer);

            // Tính điểm
            if (selectedAnswer.isCorrect()) {
                correctAnswers++;
            }
        }

        // 7. Chuyển điểm sang thang TOEIC (giả định: 10–990)
        int scaledScore = convertToToeicScore(correctAnswers, totalQuestions);
        testAttempt.setScore(scaledScore);
        testAttemptDao.save(testAttempt);

        // 8. Trả về kết quả
        return SubmitTestResponse.builder()
                .testId(testId)
                .userId(user.getId())
                .score(scaledScore)
                .totalQuestions(totalQuestions)
                .build();
    }

    private int convertToToeicScore(int correctAnswers, int totalQuestions) {
        // Tỷ lệ phần trăm đúng * 990
        double percent = (double) correctAnswers / totalQuestions;
        return Math.max(10, (int) (percent * 990));  // TOEIC min: 10
    }
}
