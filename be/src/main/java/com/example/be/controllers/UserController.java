package com.example.be.controllers;


import com.example.be.DTO.response.UserProfileDTO;
import com.example.be.database.entities.File;
import com.example.be.services.UserService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;

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
    @GetMapping("/{id}")
    public ResponseEntity<UserProfileDTO> getProfile(@PathVariable Long id) {
        UserProfileDTO profile = userService.getUserProfile(id);
        return ResponseEntity.ok(profile);
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserProfileDTO> updateProfile(@PathVariable Long id, @Valid @RequestBody UserProfileDTO profileDTO) {
        UserProfileDTO updatedProfile = userService.updateUserProfile(id, profileDTO);
        return ResponseEntity.ok(updatedProfile);
    }
    @PostMapping("/{id}/avatar")
    public ResponseEntity<File> uploadAvatar(@PathVariable Long id, @RequestParam MultipartFile file) {
        File fileEntity = userService.uploadAvatar(id, file);
        URI location = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(fileEntity.getId())
                .toUri();
        return ResponseEntity.created(location).body(fileEntity);
    }

}
