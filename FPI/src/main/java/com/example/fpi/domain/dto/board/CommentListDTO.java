package com.example.fpi.domain.dto.board;


import lombok.Data;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

//컨트롤러에 등록하는게 아니여서 component 안적어도 됨!!
@Data
public class CommentListDTO {
    private Long commentId; //시퀀스
    private Long communityId;//해당 게시글
    private String userId; //작성자아이디
    private String commentContent; //댓글내용
    private LocalDateTime commentRegisterDate; //작성일
    private LocalDateTime commentUpdateDate; //수정일
    private String userName; //작성자
}