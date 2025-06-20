package com.example.be.DTO.response;


import com.opencsv.bean.CsvBindByName;
import lombok.Data;

@Data
public class TestCSVDTO {
    @CsvBindByName(column = "test_title")
    private String testTitle;

    @CsvBindByName(column = "test_description")
    private String testDescription;

    @CsvBindByName(column = "test_type")
    private String testType;

    @CsvBindByName(column = "duration_minutes")
    private int durationMinutes;

    @CsvBindByName(column = "is_free")
    private boolean isFree;

    @CsvBindByName(column = "question_part")
    private String questionPart;

    @CsvBindByName(column = "question_content")
    private String questionContent;

    @CsvBindByName(column = "question_audio_url")
    private String questionAudioUrl;

    @CsvBindByName(column = "question_image_url")
    private String questionImageUrl;

    @CsvBindByName(column = "question_explanation")
    private String questionExplanation;

    @CsvBindByName(column = "question_difficulty")
    private String questionDifficulty;

    @CsvBindByName(column = "answer_content_1")
    private String answerContent1;

    @CsvBindByName(column = "is_correct_1")
    private boolean isCorrect1;

    @CsvBindByName(column = "answer_order_1")
    private int answerOrder1;

    @CsvBindByName(column = "answer_content_2")
    private String answerContent2;

    @CsvBindByName(column = "is_correct_2")
    private boolean isCorrect2;

    @CsvBindByName(column = "answer_order_2")
    private int answerOrder2;

    @CsvBindByName(column = "answer_content_3")
    private String answerContent3;

    @CsvBindByName(column = "is_correct_3")
    private boolean isCorrect3;

    @CsvBindByName(column = "answer_order_3")
    private int answerOrder3;

    @CsvBindByName(column = "answer_content_4")
    private String answerContent4;

    @CsvBindByName(column = "is_correct_4")
    private boolean isCorrect4;

    @CsvBindByName(column = "answer_order_4")
    private int answerOrder4;
}