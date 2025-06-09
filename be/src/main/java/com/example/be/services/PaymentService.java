package com.example.be.services;


import com.example.be.configs.VNPayConfig;
import com.example.be.utils.HashUtil;
import org.springframework.stereotype.Service;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class PaymentService {

    public String createPaymentUrl(int amount) throws Exception {
        String vnpTxnRef = String.valueOf(System.currentTimeMillis());
        String vnpOrderInfo = "Thanh toan don hang: " + vnpTxnRef;
        String vnpOrderType = "other";
        String vnpLocale = "vn";
        String vnpCurrCode = "VND";

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
        String vnpCreateDate = LocalDateTime.now().format(formatter);

        Map<String, String> vnpParams = new HashMap<>();
        vnpParams.put("vnp_Version", VNPayConfig.vnp_Version);
        vnpParams.put("vnp_Command", VNPayConfig.vnp_Command);
        vnpParams.put("vnp_TmnCode", VNPayConfig.vnp_TmnCode);
        vnpParams.put("vnp_Amount", String.valueOf(amount * 100)); // x100 theo yêu cầu
        vnpParams.put("vnp_CurrCode", vnpCurrCode);
        vnpParams.put("vnp_TxnRef", vnpTxnRef);
        vnpParams.put("vnp_OrderInfo", vnpOrderInfo);
        vnpParams.put("vnp_OrderType", vnpOrderType);
        vnpParams.put("vnp_ReturnUrl", VNPayConfig.vnp_ReturnUrl);
        vnpParams.put("vnp_IpAddr", "127.0.0.1"); // test
        vnpParams.put("vnp_CreateDate", vnpCreateDate);
        vnpParams.put("vnp_Locale", vnpLocale);

        List<String> fieldNames = new ArrayList<>(vnpParams.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query = new StringBuilder();
        for (String fieldName : fieldNames) {
            String fieldValue = vnpParams.get(fieldName);
            if (fieldValue != null && !fieldValue.isEmpty()) {
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                query.append('=');
                query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                query.append('&');

                hashData.append(fieldName);
                hashData.append('=');
                hashData.append(fieldValue);
                hashData.append('&');
            }
        }

        // Remove last &
        if (hashData.length() > 0) {
            hashData.deleteCharAt(hashData.length() - 1);
            query.deleteCharAt(query.length() - 1);
        }

        // Create secure hash
        String secureHash = HashUtil.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
        query.append("&vnp_SecureHash=").append(secureHash);

        return VNPayConfig.vnp_PayUrl + "?" + query.toString();
    }
}