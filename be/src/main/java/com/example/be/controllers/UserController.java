package com.example.be.controllers;


import com.example.be.services.UserService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
@Tag(name = "User API", description = "APIs for user account operations")
@RequiredArgsConstructor
public class UserController {


   private final UserService userService;

    @PostMapping("/{id}/upgrade-vip")
    public ResponseEntity<String> upgradeVipById(
            @PathVariable Long id,
            @RequestParam(defaultValue = "30") int days) {
        userService.upgradeToVip(id, days);
        return ResponseEntity.ok("User ID " + id + " đã được nâng cấp VIP trong " + days + " ngày.");
    }

}
