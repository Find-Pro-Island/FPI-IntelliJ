package com.example.fpi.controller.board;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@RestController
@RequestMapping("/upload")
public class SummernoteController {
    @PostMapping("/image")
    public ResponseEntity<String> uploadImage(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return new ResponseEntity<>("파일이 비어있습니다.", HttpStatus.BAD_REQUEST);
        }

        try {
            // 현재 날짜를 기반으로 폴더 경로 생성
            LocalDate now = LocalDate.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
            String datePath = now.format(formatter);

            String originalFileName = file.getOriginalFilename();
            String storedFileName = UUID.randomUUID().toString().replaceAll("-", "") + "_" + originalFileName;

            // 파일 저장 경로 설정 (프로젝트의 정적 자원 경로에 저장)
//            게시판 관리시 datePath까지는 동일
            Path directoryPath = Paths.get("src/main/resources/static/uploads/summernote/" + datePath);
            if (!Files.exists(directoryPath)) {
                Files.createDirectories(directoryPath); // 폴더가 없으면 생성
            }
            Path filePath = directoryPath.resolve(storedFileName);
            // 파일 저장
            Files.copy(file.getInputStream(), filePath);

            // 저장된 파일의 URL 반환
            String fileUrl = "/uploads/summernote/" + datePath + "/" + storedFileName;

            return ResponseEntity.ok(fileUrl);

        } catch (IOException e) {
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }
}
