package com.example.fpi.domain.dto.board;

import lombok.Data;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;


@Data
public class CommentDTO {
    private Long commentId;
    private Long communityId;
    private String userId;
    private String commentContent;
    private LocalDateTime commentRegisterDate;
    private LocalDateTime commentUpdateDate;
}
