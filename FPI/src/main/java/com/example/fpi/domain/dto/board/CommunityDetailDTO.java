package com.example.fpi.domain.dto.board;

import lombok.Data;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;


@Component
@Data
public class CommunityDetailDTO {

    private Long communityId;
    private String subject;
    private String communityTitle;
    private String communityContent;
    private String userName;
    private String userId;
    private LocalDateTime communityRegisterDate;
    private LocalDateTime communityUpdateDate;
    //좋아요 갯수
    private int likeCount;
    private String loginUserId;
    private String communityThumbnail;

}
