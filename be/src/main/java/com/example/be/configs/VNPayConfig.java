package com.example.be.configs;

import org.springframework.stereotype.Component;

public class VNPayConfig {
    public static final String vnp_Version = "2.1.0";
    public static final String vnp_Command = "pay";
    public static final String vnp_TmnCode = "YOUR_TMN_CODE";
    public static final String vnp_HashSecret = "YOUR_SECRET_KEY";
    public static final String vnp_PayUrl = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";
    public static final String vnp_ReturnUrl = "http://yourdomain.com/payment-return";
}