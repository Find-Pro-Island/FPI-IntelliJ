package com.example.fpi.domain.vo.board;

import com.example.fpi.domain.dto.board.CommentDTO;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;

@Getter
@ToString
@NoArgsConstructor
public class CommentVO {
    private Long commentId;
    private Long communityId;
    private String userId;
    private String commentContent;
    private LocalDateTime commentRegisterDate;
    private LocalDateTime commentUpdateDate;

    @Builder
    public CommentVO(Long commentId, Long communityId, String userId, String commentContent, LocalDateTime commentRegisterDate, LocalDateTime commentUpdateDate){
        this.commentId=commentId;
        this.communityId=communityId;
        this.userId=userId;
        this.commentContent=commentContent;
        this.commentRegisterDate=commentRegisterDate;
        this.commentUpdateDate=commentUpdateDate;
    }

    public static CommentVO toEntity(CommentDTO commentDTO){
        return CommentVO.builder().commentId(commentDTO.getCommentId())
                .communityId(commentDTO.getCommunityId())
                .userId(commentDTO.getUserId())
                .commentContent(commentDTO.getCommentContent())
                .commentRegisterDate(commentDTO.getCommentRegisterDate())
                .commentUpdateDate(commentDTO.getCommentUpdateDate())
                .build();
    }

}