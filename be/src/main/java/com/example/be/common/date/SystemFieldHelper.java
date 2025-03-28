package com.example.be.common.date;

import com.example.be.common.entity.SystemField;


import java.time.LocalDateTime;

public class SystemFieldHelper {
    public static SystemField setSystemFieldForInsert() {
        SystemField sf = new SystemField();
        LocalDateTime date = LocalDateTime.now();
        sf.setCreatedAt(date);
        sf.setUpdateAt(date);
        return sf;
    }
}
