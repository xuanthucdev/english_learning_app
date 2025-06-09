package com.example.be.controllers;

import com.example.be.services.PaymentService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/payment")
@RequiredArgsConstructor
public class PaymentController {

    private final PaymentService paymentService;

    @GetMapping("/create")
    public Map<String, Object> createPayment(@RequestParam(defaultValue = "100000") int amount) {
        Map<String, Object> response = new HashMap<>();
        try {
            String paymentUrl = paymentService.createPaymentUrl(amount);
            response.put("code", "00");
            response.put("message", "Success");
            response.put("paymentUrl", paymentUrl);
        } catch (Exception e) {
            e.printStackTrace();
            response.put("code", "99");
            response.put("message", "Error");
        }
        return response;
    }
}